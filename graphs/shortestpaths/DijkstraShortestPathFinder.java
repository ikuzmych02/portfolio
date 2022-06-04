package graphs.shortestpaths;

import graphs.BaseEdge;
import graphs.Graph;
import priorityqueues.DoubleMapMinPQ;
import priorityqueues.ExtrinsicMinPQ;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * Computes the shortest paths using Dijkstra's algorithm.
 * @see SPTShortestPathFinder for more documentation.
 */
public class DijkstraShortestPathFinder<G extends Graph<V, E>, V, E extends BaseEdge<V, E>>
    extends SPTShortestPathFinder<G, V, E> {

    protected <T> ExtrinsicMinPQ<T> createMinPQ() {
        return new DoubleMapMinPQ<>();
        /*
        If you have confidence in your heap implementation, you can disable the line above
        and enable the one below.
         */
        // return new ArrayHeapMinPQ<>();

        /*
        Otherwise, do not change this method.
        We override this during grading to test your code using our correct implementation so that
        you don't lose extra points if your implementation is buggy.
         */
    }

    @Override
    protected Map<V, E> constructShortestPathsTree(G graph, V start, V end) {
        double oldDist;
        double newDist;

        Map<V, E> edgeTo = new HashMap<>();
        Map<V, Double> distTo = new HashMap<>();
        ExtrinsicMinPQ<V> known = createMinPQ();
        known.add(start, 0); // add start vertex and its known distance
        // edgeTo.put(start, null);
        distTo.put(start, 0.0);
        while (!known.isEmpty()) {
            V u = known.removeMin(); // the from vertex
            if (Objects.equals(u, end)) {
                return edgeTo;
            }
            for (E edges: graph.outgoingEdgesFrom(u)) { // looking at every edge in the outgoing edges
                V v = edges.to(); // the "to" vertex
                oldDist = distTo.getOrDefault(v, Double.POSITIVE_INFINITY);
                newDist = distTo.get(u) + edges.weight();
                if (newDist < oldDist) {
                    edgeTo.put(v, edges);
                    distTo.put(v, newDist);
                    if (known.contains(v)) {
                        known.changePriority(v, newDist);
                    } else {
                        known.add(v, newDist);
                    }
                }
            }
        }
        return edgeTo;
    }

    @Override
    protected ShortestPath<V, E> extractShortestPath(Map<V, E> spt, V start, V end) {
        if (Objects.equals(start, end)) {
            return new ShortestPath.SingleVertex<>(start);
        }

        if (Objects.equals(spt, null)) {
            return new ShortestPath.Failure<>();
        }
        if (!spt.containsKey(end)) {
            return new ShortestPath.Failure<>();
        }

        List<E> edgesToEnd = new ArrayList<>();
        V current = end;


        while (!Objects.equals(spt.get(current), null)) {
            edgesToEnd.add(spt.get(current));
            current = spt.get(current).from();
        }
        Collections.reverse(edgesToEnd);
        return new ShortestPath.Success<>(edgesToEnd);
    }
}
