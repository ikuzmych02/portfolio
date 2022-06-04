package graphs.minspantrees;

import disjointsets.DisjointSets;
import disjointsets.QuickFindDisjointSets;
import graphs.BaseEdge;
import graphs.KruskalGraph;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Objects;

/**
 * Computes minimum spanning trees using Kruskal's algorithm.
 * @see MinimumSpanningTreeFinder for more documentation.
 */
public class KruskalMinimumSpanningTreeFinder<G extends KruskalGraph<V, E>, V, E extends BaseEdge<V, E>>
    implements MinimumSpanningTreeFinder<G, V, E> {

    protected DisjointSets<V> createDisjointSets() {
        return new QuickFindDisjointSets<>();
        /*
        Disable the line above and enable the one below after you've finished implementing
        your `UnionBySizeCompressingDisjointSets`.
         */
        // return new UnionBySizeCompressingDisjointSets<>();

        /*
        Otherwise, do not change this method.
        We override this during grading to test your code using our correct implementation so that
        you don't lose extra points if your implementation is buggy.
         */
    }

    @Override
    public MinimumSpanningTree<V, E> findMinimumSpanningTree(G graph) {
        // Here's some code to get you started; feel free to change or rearrange it if you'd like.
        // graph.
        // sort edges in the graph in ascending weight order
        List<E> edges = new ArrayList<>(graph.allEdges());
        List<V> vertices = new ArrayList<>(graph.allVertices());

        List<E> finalMSTEdges = new ArrayList<>();
        edges.sort(Comparator.comparingDouble(E::weight));

        if ((edges.size() == 0) && (vertices.size() == 2)) { // if there are no edges but at least one vertex
            return new MinimumSpanningTree.Failure<>();
        }
        DisjointSets<V> disjointSets = createDisjointSets();
        for (int i = 0; i < vertices.size(); i++) {
            disjointSets.makeSet(vertices.get(i));
        }

        int i = 0;

        while (i < edges.size()) {
            V uMSTFrom = edges.get(i).from();
            V vMSTTo= edges.get(i).to();

            if (!Objects.equals(disjointSets.findSet(uMSTFrom), disjointSets.findSet((vMSTTo)))) {
                disjointSets.union(uMSTFrom, vMSTTo);
                finalMSTEdges.add(edges.get(i));
            }
            i++;
        }
        int baseCase;
        if (vertices.size() != 0) {
            baseCase = disjointSets.findSet(vertices.get(0));


            for (int j = 0; j < finalMSTEdges.size(); j++) {
                V fromVertex = finalMSTEdges.get(j).from();
                V toVertex = finalMSTEdges.get(j).to();
                int fromFindSet = disjointSets.findSet(fromVertex);
                int toFindSet = disjointSets.findSet(toVertex);

                if ((fromFindSet != baseCase) || (toFindSet != baseCase)) {
                    return new MinimumSpanningTree.Failure<>();
                }
            }
            return new MinimumSpanningTree.Success<V, E>(finalMSTEdges);
        }
        return new MinimumSpanningTree.Success<>();
    }
}
