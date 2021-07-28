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
   val towns = readInt inStream
   val cars = readInt inStream
   val _ = TextIO.inputLine inStream
   val empty =  Array.tabulate(towns,fn x => 0)	(* creates an empty int array *)

   fun readInts 0 sumd acc has = (sumd, acc, rev(has))
     | readInts i sumd acc has=
         let
              val x = readInt inStream
              val sumd = sumd + x
              val f = Array.sub(acc, x)
              val f = f + 1
              val has = if(f=1) then (x::has) else has
              val upd = Array.update(acc,x, f)
          in
              (readInts (i - 1) sumd acc has)
          end
 in
      (towns, cars, readInts cars 0 empty [])
 end
(* ................................................................*)
fun round file =
    let
        val (towns, cars, positions) = parse file
        val freq =  #2 positions   (* array with num of cars per town *)
        val withcars = #3 positions
        val town = 0
        val min= towns*cars(* impossible *)

        fun distance _ _ _ [] _ sum maxi = (sum, maxi)
          |distance towns ar town (j::rest) cur sum maxi =
            let
                val x = if(j<town) then
                (town - j)
                else if (j>town) then (towns +town -j)
                else 0
                (*val p = print("distance between "^Int.toString(town)^" and"^Int.toString(j)^" is "^Int.toString(x)^"\n")*)
                val maxi = if (x>maxi) then x else maxi;           (* max distance from town *)
                val sum = sum + x * Array.sub(ar, j)
                (*val debug = print(Int.toString(sum)^"\n") *)
            in
                if(sum>cur) then (cur, cur+1)
                else (distance towns ar town rest cur sum maxi)
           end

        fun target towns (ar:int array) destination (l:int list) town sum min =
            let
                val (y, mx)= distance towns ar town l min 0 0
                (*val deb = print("town:"^ Int.toString(town))
                val ug = print("(sum, maxd)="^Int.toString(y)^Int.toString(mx)^"\n") *)
                val check = if(y -mx >= mx -1) then true else false
                val (min, destination) = if(check=true andalso y <min) then  (y, town) else (min, destination)
                val town = town+1     (* check the next town *)
            in
                if(town<towns) then (target towns ar destination l town 0 min)
                else (min, destination)
            end
        in
            let
             val (moves, dest) = target towns freq 0 withcars 0  0 min
            in
              print(Int.toString(moves)^" "^Int.toString(dest)^"\n")
            end
        end
