import java.util.*;
import java.io.*;

/*List<List<Integer>> init = Arrays.asList(initial.Qin, initial.Sin); */

public class QSsort{
  // The main function.
  public static void main(String args[]) {
    List<Integer> Qinit = new ArrayList<Integer>();
    List<Integer> Sinit = new ArrayList<Integer>();

	  try {
        File input = new File(args[0]);
        BufferedReader bi = new BufferedReader (new FileReader(input));
        String line[] ;
        line = bi.readLine().split("\\s");
        int N = Integer.parseInt(line[0]);
        line = bi.readLine().split("\\s");
        for(int i=0; i<line.length; i++) {
            Qinit.add(Integer.parseInt(line[i]));
        }
    }catch (Exception e){
        System.out.println("Please provide an input file.");
      }

    zQSState initial = new zQSState(Qinit, Sinit, null, (short)2);

    if(initial.isFinal()){
      System.out.println("empty");
      return;
    }
    else{
       StringBuilder result = BFSsolver(initial);
      System.out.println(result.toString());
    }
    return;
  }

  public static  StringBuilder BFSsolver(zQSState in) {

    Queue<zQSState> remaining = new ArrayDeque<>();
    Set<List<List<Integer>>> seen = new HashSet<>();
		List<List<Integer>> init = Arrays.asList(in.Qin, in.Sin);
    seen.add(init);
    remaining.add(in);
    zQSState s = null;
    List<Integer> stack = null;
    List<Integer> queue = null;

    while (!remaining.isEmpty()) {

         s = remaining.remove();
         if(s.Sin.isEmpty() && s.isFinal()) {
        	 break;

         }
         stack = s.Sin;
         queue = s.Qin;

         //Q_move
         if(!queue.isEmpty()){
           List<Integer> qQ = new ArrayList<Integer>(queue);
           List<Integer> sS = new ArrayList<Integer>(stack);
           // Qmove
           sS.add(0, qQ.remove(0));   // add qQ head to Stack
           zQSState n = new zQSState(qQ, sS, s, (short)0);
           List<List<Integer>> a = new ArrayList<List<Integer>>(2);
           a.add(qQ);
           a.add(sS);
          //   System.out.println("made a Q move");
           if(seen.add(a)) {
                 remaining.add(n);
           }
         }

         //S_move
        if(!stack.isEmpty() && !queue.isEmpty() && (stack.get(0)!= queue.get(0))){
            List<Integer> qQ = new ArrayList<Integer>(queue);
            List<Integer> sS = new ArrayList<Integer>(stack);
            qQ.add(sS.remove(0));
            zQSState p =  new zQSState(qQ, sS, s, (short)1);
            List<List<Integer>> b = new ArrayList<List<Integer>>(2);
            b.add(qQ);
            b.add(sS);
      //      System.out.println(b);
          //  System.out.println("made a S move");
            if (seen.add(b)) {
            //     System.out.println(seen);
                 remaining.add(p);
            }
           }

      }

      StringBuilder moves = new StringBuilder();
      zQSState now = s;
			ArrayList<Character> revpath = new ArrayList<Character>();
      revpath.add('S');
      short w = 2;
      while(true) {
              now = now.prev;
              w = now.move;
							if(w==2) {
                break;
              }

							if(w==0){
    	            revpath.add('Q');
							}
							else{
    	            revpath.add('S');
							}
      }
			for(int i = revpath.size() - 1; i >= 0; i--){
	           moves.append(revpath.get(i));
      }
			return moves;
    }

    public boolean equals(List<List<Integer>> o) {
   //   if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;
      List<List<Integer>> other = o;
      return o.get(0) == other.get(0) && o.get(1) == other.get(1);
    }


   public int hashCode(List<List<Integer>> l) {
     return Objects.hash(l);
   }


 }
