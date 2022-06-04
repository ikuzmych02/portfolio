package disjointsets;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.Stack;

/**
 * A quick-union-by-size data structure with path compression.
 * @see DisjointSets for more documentation.
 */
public class UnionBySizeCompressingDisjointSets<T> implements DisjointSets<T> {
    // Do NOT rename or delete this field. We will be inspecting it directly in our private tests.
    List<Integer> pointers;
    Map<T, Integer> elementIndices;


    /*
    However, feel free to add more fields and private helper methods. You will probably need to
    add one or two more fields in order to successfully implement this class.
    */

    public UnionBySizeCompressingDisjointSets() {
        pointers = new ArrayList<>();
        elementIndices = new HashMap<>();
    }

    @Override
    public void makeSet(T item) {
        if (!elementIndices.containsKey(item)) {
            pointers.add(-1);
            elementIndices.put(item, pointers.size() - 1); // index of the new set
        } else {
            throw new IllegalArgumentException("Element already exists in the set bozo");
        }
    }

    @Override
    public int findSet(T item) {
        Stack<Integer> pathCompressed = new Stack<>();
        int i;
        if (!elementIndices.containsKey(item)) {
            throw new IllegalArgumentException("This element does not exist bozo");
        } else {
            i = elementIndices.get(item);
            while (pointers.get(i) >= 0) {
                pathCompressed.push(i);
                i = pointers.get(i);
            }
            while (!pathCompressed.isEmpty()) { // should do the path compression
                pointers.set(pathCompressed.pop(), i);
            }
            return i;
        }
    }

    @Override
    public boolean union(T item1, T item2) {
        int root1;
        int root2;

        root1 = findSet(item1);
        root2 = findSet(item2);
        if (root1 == root2) {
            return false;
        }
        int weight1 = pointers.get(root1) * -1;
        int weight2 = pointers.get(root2) * -1;
        if (weight2 > weight1) {
            pointers.set(root1, root2);
            pointers.set(root2, (weight1 + weight2) * -1); // update the weight
        } else {
            pointers.set(root2, root1);
            pointers.set(root1, (weight1 + weight2) * -1); // update the weight
        }
        return true;
    }
}
