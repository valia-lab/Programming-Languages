import java.util.*;
import java.io.*;

public class QSsort{
	// The main function.
	public static void main(String args[]) {
		Stack<Integer> Sinit = new Stack<Integer>();       //defines an empty stack
		ArrayDeque<Integer> Qinit = new ArrayDeque<Integer>();

		try {
			Scanner scanner = new Scanner(new File(args[0]));
			int N = scanner.nextInt();   // N inputs

			for(int i = 0; i < N; i++ ){
				Qinit.add(scanner.nextInt());
			}
			scanner.close();

		}catch (FileNotFoundException e){
			System.out.println("Please provide an input file.");
		}

		QS_State initial = new QS_State(Qinit, Sinit);
		if(initial.isFinal(initial)){
			System.out.println("empty");
			return;
		}
		StringBuilder result = new StringBuilder();
		result = BFSsolver(initial);


		if (result == null) {
			System.out.println("No solution found.");
		} else {
			System.out.println(result.toString());
		}
	}
	//..................................................................................//

	public static StringBuilder BFSsolver(QS_State initial) {

		Queue<QS_State> remaining = new ArrayDeque<>();
		HashMap<QS_State,tuple<QS_State, Character>> seen = new HashMap<>();
		QS_State res = initial;

		remaining.add(initial);
		tuple<QS_State, Character> none = new tuple<QS_State, Character>();
		none.put(null, null);                      // before initial we did not went to any other state
		seen.put(initial, none);
		QS_State s = null;

		while (!remaining.isEmpty()) {

			s = remaining.remove();

			//Q_move
			for (QS_State n : s.nextQ(s)) {
				if (!seen.containsKey(n)) {
					remaining.add(n);
					tuple<QS_State, Character> t = new tuple<QS_State, Character>();
					t.put(s, 'Q');
					seen.put(n, t);
				}
			}


			//S_move
			for (QS_State n : s.nextS(s)) {
				if (!seen.containsKey(n)) {
					remaining.add(n);
					tuple<QS_State, Character> t = new tuple<QS_State, Character>();
					t.put(s, 'S');
					seen.put(n, t);
				}

			}
			if(s.isFinal(s)) {
				break;
			}

		}

		StringBuilder moves = new StringBuilder();
		ArrayList<Character> rev_path = new ArrayList<Character>();
		QS_State prev = s;
		Character w = null;
		tuple<QS_State, Character> i = new tuple<QS_State, Character>();
		while(prev!=null) {
			i = seen.get(prev);  // tuple
			w = i.getMove(i);
			if(w == null ) break;
			rev_path.add(w);
			prev = i.getPrev(i);
		}
		for(int j = rev_path.size() - 1; j>= 0; j--){
        moves.append(rev_path.get(j));
    }
    return moves;

	}
}
