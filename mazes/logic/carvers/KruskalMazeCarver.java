package mazes.logic.carvers;

import graphs.EdgeWithData;
import graphs.minspantrees.MinimumSpanningTree;
import graphs.minspantrees.MinimumSpanningTreeFinder;
import mazes.entities.Room;
import mazes.entities.Wall;
import mazes.logic.MazeGraph;


import java.util.LinkedHashSet;
import java.util.Random;
import java.util.Set;
import java.util.List;
import java.util.ArrayList;

/**
 * Carves out a maze based on Kruskal's algorithm.
 */
public class KruskalMazeCarver extends MazeCarver {
    MinimumSpanningTreeFinder<MazeGraph, Room, EdgeWithData<Room, Wall>> minimumSpanningTreeFinder;
    private final Random rand;

    public KruskalMazeCarver(MinimumSpanningTreeFinder
                                 <MazeGraph, Room, EdgeWithData<Room, Wall>> minimumSpanningTreeFinder) {
        this.minimumSpanningTreeFinder = minimumSpanningTreeFinder;
        this.rand = new Random();
    }

    public KruskalMazeCarver(MinimumSpanningTreeFinder
                                 <MazeGraph, Room, EdgeWithData<Room, Wall>> minimumSpanningTreeFinder,
                             long seed) {
        this.minimumSpanningTreeFinder = minimumSpanningTreeFinder;
        this.rand = new Random(seed);
    }

    @Override
    protected Set<Wall> chooseWallsToRemove(Set<Wall> walls) {
        List<EdgeWithData<Room, Wall>> edgeData = new ArrayList<>();
        for (Wall vertexData: walls) {
            edgeData.add(new EdgeWithData<>(vertexData.getRoom1(), vertexData.getRoom2(),
                rand.nextDouble(), vertexData));
        }

        MinimumSpanningTree<Room, EdgeWithData<Room, Wall>> minSpanTree;
        minSpanTree = this.minimumSpanningTreeFinder.findMinimumSpanningTree(new MazeGraph(edgeData));

        Set<Wall> removableWalls = new LinkedHashSet<>();
        for (EdgeWithData<Room, Wall> edge: minSpanTree.edges()) {
            removableWalls.add(edge.data());
        }
        return removableWalls;
    }

}
