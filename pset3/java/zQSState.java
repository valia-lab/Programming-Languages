import java.util.*;

public class zQSState{
	  public List<Integer> Qin;
	  public List<Integer> Sin;
    public zQSState prev;
		public short move;

	  public zQSState(List<Integer> Q, List<Integer> S, zQSState p, short m) {
		Qin = Q;
		Sin = S;
		prev = p;
		move = m;
	  }

	  public boolean isFinal() {

		int prev = Qin.get(0);
	    for(int m : Qin){                             // checks if Qin is sorted
	          if(m<prev) return false;
			  else prev = m;
	    }
	    return true;
	  }

}
