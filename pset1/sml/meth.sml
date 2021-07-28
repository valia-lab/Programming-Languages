   (* Input parse code is based on the code  publicly available here:
      https://courses.softlab.ntua.gr/pl1/2013a/Exercises/countries.sml we were (kindly) recommended to use, by our professor*)


fun parse file =
    let
    (* A function to read an integer from specified input. *)
        fun readInt input = 
        Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

    (* Open input file. *)
    	val inStream = TextIO.openIn file

        (* Read 2 integers (number of inputs & hospitals) and consume newline. *)
    val inputs = readInt inStream
    val n = readInt inStream
    val _ = TextIO.inputLine inStream 
        (* A function to read N integers from the open file. *)
    fun readInts 0 acc = acc (* Replace with 'rev acc' for proper order. *)
      | readInts i acc = readInts (i - 1) (readInt inStream :: acc)   
    in
         (inputs, n,  readInts inputs []) 
    end
(* ................................................................*)
val all = 0
val b2 = 0
val f1 = 0

(*checks if it's a "good period" and updates d if it is *)
fun ratio sum_1 sum_2 n k (d:real) = 
    if  sum_1<0.0 andalso ( (~sum_1)/(n*k) )>1.0 andalso k>d
                  then  k
    else if sum_2<0.0 andalso ((~sum_2)/(n*k))>1.0 andalso k>d
                  then  k
    else d 
 

fun days (l, f1,f2, sumf:real, b2, sumb:real, d:real, n)   = 
          let 
               val sumf = sumf - Real.fromInt(Array.sub(l,f1)) (* pop front *)
               val sumb = sumb - Real.fromInt(Array.sub(l,b2)) (* pop back *) 
               val k = Real.fromInt(f2-f1)
               val d = ratio sumf sumb n k d
               val f1 = f1+1
               val b2 = b2-1
               val k = Real.fromInt(f2-f1) 
          in
               if(f1<f2 andalso k>d) then days(l,f1,f2, sumf, b2, sumb, d, n) 
               else d           
          end; 
 
                                       
fun loop l f2 b1 b_2 (sumf_c:real) (sumb_c:real) (d:real) n = 
 let 
       val d = days (l, f1,f2 , sumf_c, b_2, sumb_c,d, n) 
       val sumf_c = sumf_c - Real.fromInt(Array.sub(l,f2))
       val sumb_c = sumb_c -Real.fromInt(Array.sub(l,b1))
       val f1 = 0
       val b2 = b_2
       val f2 = f2-1
       val b1 = b1+1
       val k = Real.fromInt(f2-f1);
 in   
      if(f1<f2 andalso d<k) then  
        loop l f2 b1 b_2 sumf_c sumb_c d n
      else trunc(d)
 end;
 
fun frst (x,_,_) = x
fun scnd (_,x,_) = x
fun thrd (_,_,x) = x

fun longest Infile = 
     let 
          val i_n = parse Infile
          val inputs = frst i_n  (* number of inputs *)
          val m = Real.fromInt(scnd i_n ) (* hospitals *)
          val inputList = thrd i_n
          val sb_c  = Real.fromInt(foldr (op +) 0 inputList) (* sum of all elements *)
          val sf_c = sb_c
          val input = Array.fromList(inputList)
          val front2 = inputs-1
          val back2 = front2
          val k  = Real.fromInt(inputs)
     in   
          if(sb_c <0.0 andalso ratio  sb_c sf_c m k 0.0 > 0.0) then 
          print(Int.toString(trunc(k)) ^ "\n")
          else
          print(Int.toString(loop input front2 0 back2 sf_c sb_c 0.0 m)^ "\n")  
     end

