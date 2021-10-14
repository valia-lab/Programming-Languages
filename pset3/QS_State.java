import java.util.Collection;
import java.util.*;

public class QS_State{
	  private ArrayDeque<Integer> Qin;
	  private Stack<Integer> Sin;

	  public QS_State(ArrayDeque<Integer> Q, Stack<Integer> S) {
		Qin = Q;
		Sin = S;
	  }

	  public boolean isFinal(QS_State s) {
    if(!s.Sin.isEmpty()) return false;
		int prev = s.Qin.getFirst();
	    for(int m : s.Qin){                             // checks if Qin is sorted
	          if(m<prev) return false;
			  else prev = m;
	    }
	    return true;
	  }

	  public Collection<QS_State> nextQ(QS_State s) {
	    Collection<QS_State> states = new ArrayList<QS_State>(); // next returns a Collection
	    ArrayDeque<Integer> qQ = new ArrayDeque<Integer>();
		  qQ = s.Qin.clone();
		  Stack<Integer> stack = ((Stack<Integer>)s.Sin.clone());
		  Stack<Integer> clone = stack;
		  Stack<Integer> sS = clone;
		  int h = 0;

		  if(!qQ.isEmpty()){            // Qmove
			  sS.push(qQ.element());   // add qQ head to Stack
		    qQ.remove();
		  }
		  states.add(new QS_State(qQ, sS));
		  return states;
	  }

	  public Collection<QS_State> nextS(QS_State s) {
		  Collection<QS_State> states = new ArrayList<>(); // next returns a Collection
		  ArrayDeque<Integer> qQ;
		  qQ = s.Qin.clone();
		  Stack<Integer> sS = (Stack<Integer>)s.Sin.clone();
		  int h = 0;

		  if(!sS.empty()){             // Smove
		      h = sS.pop();
		      qQ.add(h);
		  }
		  states.add(new QS_State(qQ, sS));
		  return states;
	  }

	  // Hashing: consider only Queue and Stack instance at this point
	  @Override
	  public int hashCode() {
	    return Objects.hash(Qin, Sin);
	  }

	    // Two states are equal if Queue and Stack are idenctical
	  @Override
	  public boolean equals(Object o) {
	    if (this == o) return true;
	    if (o == null || getClass() != o.getClass()) return false;
	    QS_State other = (QS_State) o;
	    return Qin == other.Qin && Sin == other.Sin;
	  }



}
