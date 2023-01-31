#!/bin/bash

func_names_path="$PWD/input/func_names" # file that contains names of the functions to be synthesized
num_syn_funs=0 #number of functions to be synthesized
syn_funs_codes=() #array representing the codes for the functions to be synthesized for different runs
curr_syn_funs=1 #variable representing the code for the current functions to be synthezied
LC_sketch_calls=0 #number of LC sketch calls
LE_sketch_calls=0 #number of LE sketch calls
CEX_num=0
stepwise_time=()
total_time_start=$(date +%s.%N)
derivation_time=0

R_bv=0
Z_bv=0
gap=1
enable_crest=0
#sort string based on length
#perl -e 'print sort { length($a) <=> length($b) } <>'


#~~~~~~~~~~~~~~~~~ Function that decides the combinations of functions to be synthesized ~~~~"
get_syn_funs_codes()
{
      return
        ####################
      echo "in get_syn_funs_codes"
      #single hole at a time
      i=0
      n=1  
      echo "n = "$n
      while [ $i -lt $num_syn_funs ] ;
      do
              #n=$(( n + (1 << i) ))
              n=$(( 1 << i ))
              echo "i = "$i", n = "$n
              syn_funs_codes+=($n)
              i=$(( i + 1))
      done
      echo "${syn_funs_codes[@]}"
      return
      #multiple holes at a time
      i=1
      n=1  
      echo "n = "$n
      while [ $i -lt $num_syn_funs ] ;
      do
              n=$(( n + (1 << i) ))
              #n=$(( 1 << i ))
              echo "i = "$i", n = "$n
              syn_funs_codes+=" $n "
              i=$(( i + 1 ))
      done
      #syn_funs_codes=$(( 127  )) 
}

replicate_input()
{   
    mkdir dev_seed
    cd input/dev_seed_in/
    mkdir ../dev_seed > /dev/null
    rm ../dev_seed/* > /dev/null
    list=($(ls))
    for i in "${list[@]}";
    do
        cp $i temp
        perl -pe 's{NUM}{ sprintf "%d",  int(3*rand()+1 ) }ge' temp > ../dev_seed/$i
        rm temp
    done
    cd ../../
}

#pkalita

create_seed_from_code(){
    cd syn/
    rm -r code_files > /dev/null 2>&1
    mkdir code_files
    cp ../input/code_files/* ./code_files
    rm testRes > /dev/null 2>&1
    cd code_files
    list=($(ls | sort -g))
    for i in "${list[@]}"; do
        echo "File: "$i
        gcc -o testBin $i 
        if [ $? -ne 0 ]
        then 
            echo "Compile error in test cases"  
            exit
        fi
        ./testBin >> testRes
        
    done
    
    cd ../ 

    flex gram.l
    bison -d --defines="yacc.tab.h" --output="yacc.tab.c" gram.y
    g++ -g  -no-pie  -I ../include/  lex.yy.c yacc.tab.c  oracle_funs.cpp  -o gram_oracle
    
    while IFS= read -r line;
    do
        echo "$line" > dump
        perl -pe 's{NUM}{ sprintf "%d",  int(3*rand()+1 ) }ge' dump > dmp
        mv dmp dump
        rm ./getDerivation  > /dev/null 2>&1
        ./gram_oracle < dump

        derivationList=()
        
        ls ./getDerivation > /dev/null
        if [ $? -ne 0 ];    
        then
            echo "getDerivation is not there"
            exit
        fi

        while IFS= read -r tmp;
        do
            derivationList+=($tmp)
        done < ./getDerivation

        devCode=0
        for i in "${derivationList[@]}"; do
            devCode=$(( devCode | i ))
            #devCode=$tmp
        done
        #echo "$devCode"
        
        rm gen_sketch/dev_seed/ > /dev/null 2>&1
        mkdir gen_sketch/dev_seed/

        for i in 1 2 3 4 5
        do
            echo "$line" >> gen_sketch/dev_seed/$devCode
        done


    done < testRes   
}


create_seed()
{
    echo "Inside create seed"
    cd syn/    
    cp ../input/aux_fun.c .  2>&1 1>/dev/null 
    
    flex gram.l
    bison -d --defines="yacc.tab.h" --output="yacc.tab.c" gram.y
    g++ -g  -no-pie  -I ../include/  lex.yy.c yacc.tab.c  oracle_funs.cpp  -o gram_oracle

    cd gen_sketch/dev_seed/

    cat /dev/null >$input_seed_path    
    #touch $input_seed_path    

    list=($(ls | sort -g))
    echo "Printing list from create_seed"
    echo "${list[@]}"
    for i in "${list[@]}"; do
        cp $i temp
        cp $i input
		while IFS= read -r line; 
		do
            echo "$line" > input_line
            op_oracle=$(../../gram_oracle < input_line )
            echo "$line = $op_oracle" >> $i"_eval"
        done < temp
        rm temp
    done
    
    for i in "${list[@]}"; do
        tmp=$(head -1 $i) 
        echo "$tmp" >> $input_seed_path
    done

    if false
    then
    tempList=()
    #creating input seed by taking one input from each
    for i in "${list[@]}"; do
        while IFS= read -r ln;
        do
            echo "lline : " $i " -- " $ln
            tempList+=($ln)
            break
        done < $i
        #echo $i >> $input_seed_path
    done

    
    for i in "${tempList[@]}" ; do
        echo $i >> $input_seed_path
    done

    echo "~~~~~~~~~~~~~~~~"
    fi    
    cat $input_seed_path

    cd ../../../
    echo "Seed ends"
}


create_sep_hole()
{
    cd syn/gen_sketch/
    mkdir fun_holes_dir > /dev/null
    rm fun_holes_dir/*
    cd fun_holes_dir
    iter=0
    for i in "${fun_map_list[@]}"; do
         fun="${fun_name_list[$iter]}"
         bash ../../../getFunDef.sh $fun_hole $fun > $i.cpp
         bash ../../../getFunDef.sh $fun_hole_sk $fun > $i.sk
         iter=$(( iter + 1 ))
    done
    cd ../../../
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Starting of Main Code ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

terms_path="$PWD/syn/enum/terms"  # file that contains the derivation coverage terminals of grammar

echo "===== copying input files ====="
cp ./input/oracle_funs.cpp syn/ # oracle function code
cp ./input/gram.l syn/ 
cp ./input/gram.y syn/ 
cp ./input/input_seed syn/gen_sketch/input #copying input seed for starting synthesis of sketch
cp ./input/gen_sketch.y syn/gen_sketch/ 
cp ./input/gram.l syn/gen_sketch/gen_sketch.l
cp ./input/derive_grammar.c syn/enum/ #derivation grammar
cp ./input/gram.h syn/ > /dev/null 2>&1

input_seed_path="$PWD/input/input_seed"
fun_map_path="$PWD/input/fun_map"

fun_hole="$PWD/input/hole_oracle.cpp"
fun_hole_sk="$PWD/input/hole_oracle.sk"


ls $fun_map_path > /dev/null
if [ $? -ne 0 ]
then
    echo "add function map"
    exit
fi

fun_map_list=()
while IFS= read -r line;
do
    fun_map_list+=($line)
done < $fun_map_path



ls input/hole_oracle.cpp
if [ $? -ne 0 ]
then
    echo "Add hole_oracle"
    exit
fi

cp  input/hole_oracle.cpp syn/gen_sketch/


start=$(date +%s.%N)

if [ $enable_crest -eq 1 ]; then 
    cd syn/enum
    #bash run.sh >/dev/null 2>&1
    bash create_dev_seed.sh >/dev/null 2>&1
    cd ../../  # main directory
fi 

replicate_input
rm -r syn/gen_sketch/dev_seed
cp -r input/dev_seed/ syn/gen_sketch/

derivation_time=$(echo "$(date +%s.%N) - $start" | bc)

# have to make a flag to decide which one to call

compilerFlag=0

if [[ $compilerFlag -ne 0 ]]
then 
    create_seed_from_code
fi


create_seed



echo "===== creating func_names ====="


#ctags --sort=no -x input/oracle_funs.cpp  | awk '{ print $1 }' > input/func_names
num_syn_funs=$( wc -l input/func_names | cut -d " " -f 1) # number of functions to be synthesized

fun_name_list=()
while IFS= read -r name;
do
    fun_name_list+=("$name")
done < input/func_names

echo "name- " "${fun_name_list[@]}"
echo "map- " "${fun_map_list[@]}"

if [ ${#fun_name_list[@]} -ne ${#fun_map_list[@]} ]
then
    echo "Map and functions name should be of same size"
    exit
fi

create_sep_hole


echo "===== cleaning previous contents  ======="
cd syn 
#make clean >/dev/null  2>&1  #cleaning syn build contents

# we are still in syn
cd gen_sketch
make clean >/dev/null 2>&1  #cleaning gen_sketch  build contents
make >/dev/null 2>&1 
cd ../../ # main directory



echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "================================ starting the synthesizer ========================="
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
get_syn_funs_codes 2>&1 1>/dev/null  # getting the codes for set of combinations of functions to be synthesized

NUM_RUNS=1



oneadd=$((num_syn_funs + 2 ))
max_bv=$(( 2 ** oneadd - 1 ))

for run in $(seq 1 $NUM_RUNS)
do
    synth_time_start=$(date +%s.%N)

	rm results_$run 2>&1 1>/dev/null # removing results file if already present
    echo "derivation time " $derivation_time >> results_$run

    #for i in "${syn_funs_codes[@]}" ;
    while IFS= read -r line;
	do
        echo "================================= new input from input_seed"
        inp_time_start=$(date +%s.%N)
        
        len1=${#line}
        #if [ $len1 -ge 30 ]; 
        if [ 1 == 0 ];
        then    
            echo "There is an issue with input"
            echo $line
            exit
        fi 

		#curr_syn_funs=$i # code of current functions to be synthesized
        check_bit=0
        cd syn 
        echo "$line" > current_line
        cp current_line input

        ls gram_oracle > /dev/null
        if  [ $? -ne 0 ]
        then 
            echo "gram oracle is missing"
        fi

        rm getDerivation
        ./gram_oracle < current_line
        cat current_line
        echo "Derivation in this iteration"
        cat getDerivation
    
        derivationList=()

        #IFS=$'\n' read -d '' -r -a derivationList < getDerivation
        
        while IFS= read -r tmp;
        do
            derivationList+=($tmp)
        done < ./getDerivation
        
        Z_bv=0
        
        only_for_java=1

        fun_to_syn=()
        #Z_bv is the bitvector containing which function is in the list
        for i in "${derivationList[@]}"; do
            tmp=$(( Z_bv | i ))
            Z_bv=$tmp
            #tmp=$(( R_bv & i ))
                
            fun_to_syn+=($i)

            only_for_java=$(( 1 + i ))
        done
        
        #echo "getDeriavation Z_bv " $Z_bv
        #echo "getDeriavation R_bv " $R_bv

        and_res=$(( Z_bv & R_bv ))
        
        if [ $Z_bv -eq 0 ]
        then
            echo "Z is zero"
            echo "Derivation list " "${derivationList[@]}"
            cd ..
            continue
            #exit
        fi

        #if false; then
        if [ $and_res == $Z_bv ] 
        then 
            #echo "It should not hit actually"
            ls gram_oracle >/dev/null
            if [ $? -ne 0 ]
            then
                echo "gram_oracle is missing?"
            fi
            cp oracle_funs.cpp oracle_funs.cpp.bak

            cat /dev/null > oracle_funs.cpp
            
            ls ../input/header.txt
            if [ $? == 0 ]
            then
                cat ../input/header.txt >> oracle_funs.cpp
                cp ../input/gram.h .
            fi

            ls ../input/aux_fun.c  2>&1 1>/dev/null 
            if [ $? == 0 ]
            then
                echo "#include \"aux_fun.c\"" >> oracle_funs.cpp
                cp ../input/aux_fun.c .
            fi

            echo "#include<assert.h>" >> oracle_funs.cpp
            echo "extern \"C\"{" >> oracle_funs.cpp

            for i in "${fun_map_list[@]}"; do
                cat gen_sketch/fun_holes_dir/$i.cpp >> oracle_funs.cpp
            done
            echo "}" >> oracle_funs.cpp
            cp oracle_funs.cpp yo.cpp

   	        flex gram.l
   	        bison -d --defines="yacc.tab.h" --output="yacc.tab.c" gram.y
            g++ -g  -no-pie  -I ../include/  lex.yy.c yacc.tab.c  oracle_funs.cpp  -o gram
            
            cp oracle_funs.cpp.bak oracle_funs.cpp

            # now test with every element
            while IFS= read -r sample;
            do
                echo "$sample" > sample_in
                op_gram=$(./gram < sample_in )
                op_oracle=$(./gram_oracle < sample_in)
                
                echo "$sample" ", "  "$op_gram" ", " "$op_oracle" 
                
                if [ "$op_gram" != "$op_oracle" ]
                then
                    check_bit=1
		            echo "Found counter example " $op_gram  " " $op_oracle
                    CEX_num=$(( CEX_num + 1 ))
                   break 
                fi
            done < ./gen_sketch/dev_seed/$Z_bv
    
            
            if [ $check_bit == 0 ] 
            then
                cd ../
                continue
                
            fi
            
            if [ $check_bit == 1 ] 
            then
                for i in "${derivationList[@]}"; do
                    #since there is a counterexample for synthesized functions hence have to remove all the defn which are in Z_bv
                    tmp=$(( R_bv & $i ))
                    if [ $tmp == $i ] 
                    then
                        tmp=$(( R_bv ^ $i ))
                        R_bv=$tmp
                      #  fun_to_syn+=($i)
                    fi
                done
            fi
        fi
        #fi #for false
        
			
			cd ./gen_sketch
			rm gen_sketch
          	make  > /dev/null 2>&1
    
			start=$(date +%s.%N) # start time of step L_AB
			echo "1" > ./last_F_bar_id  # synthesizing only F
            cp ./dev_seed/$Z_bv input


            sketch_code=$(( $max_bv ^ $R_bv ))    
            cat ./dev_seed/$Z_bv > cumulative_sample
            cat ./dev_seed/$Z_bv"_eval" > cumulative_sample_eval

            count=0
            t=0
            if [ $check_bit -eq 1 ]; 
            then
                echo "ADDING NEW EXAMPLES"
                #add the new values to cumulative_sample_eval
                for i in "${derivationList[@]}"; do
                    t=$(( t | i ))
                    ((count=count+1))
                    if [ $count -eq $gap ]; 
                    then
                        ls ./dev_seed/$t > /dev/null 2>&1
                        if [ $? == 0 ]; then
                        
                            cat ./dev_seed/$t >> cumulative_sample
                            cat ./dev_seed/$t"_eval" >> cumulative_sample_eval
                        fi
                    fi
                done
            fi


            cp cumulative_sample_eval input
		    rm ../gram.sk
            rm gram.sk
            make clean > /dev/null 2>&1
            make > /dev/null 2>&1
		    pwd
			./gen_sketch $sketch_code  <  ./cumulative_sample_eval > gram.sk  #./input > ../gram.sk # sketch file for F
			if [ $? -ne 0 ]
			then 
				echo "compile error with " $sketch_code
				exit
			fi
            cp gram.sk ../
	        rm gram.cpp
	    	echo "calling sketch"
		    rm -r ~/.sketch/tmp
			#sketch -p cleanup  --slv-nativeints --fe-output-code  --slv-parallel --slv-p-cpus 4 --slv-timeout 10 --slv-synth MINI ../gram.sk 2>err 1>useful   # checking for satisfiablity
			sketch --slv-parallel -p cleanup  --bnd-int-range 1000 --slv-parallel --fe-output-code --slv-p-cpus 8  --slv-timeout 10 --slv-synth MINI ../gram.sk 2>err 1>useful   # checking for satisfiablity
			#sketch --slv-nativeints -p cleanup --fe-output-code --slv-timeout 10 ../gram.sk 2>&1 1>/dev/null # checking for satisfiablity
			ls gram.cpp
			if [ $? -ne 0 ]
			then
				echo "UNSAT at F : Cannot meet specification(this error can't be reached ) "
                echo "Couldnot solve for " $Z_bv
                and_res=$(( Z_bv & R_bv ))
                if [ $and_res -ne 0 ]
                then
                    for i in "${derivationList[@]}"; do
                    	#since there is a counterexample for synthesized functions hence have to remove all the defn which are in Z_bv
                        tmp=$(( R_bv & $i ))
                        if [ $tmp == $i ] 
                        then
                           tmp=$(( R_bv ^ $i ))
                           R_bv=$tmp
                        #  fun_to_syn+=($i)
                        fi
                    done

                    sketch_code=$(( $max_bv ^ $Z_bv ))    
		            rm ../gram.sk
                    rm gram.sk
                    make clean > /dev/null 2>&1
                    make > /dev/null 2>&1

                    #only for java byte code
			        #./gen_sketch $sketch_code  <  ./cumulative_sample_eval > gram.sk  #./input > ../gram.sk # sketch file for F


			        ./gen_sketch $Z_bv  <  ./cumulative_sample_eval > gram.sk  #./input > ../gram.sk # sketch file for F
                    cp gram.sk ../
			        #sketch  -p cleanup   --fe-output-code --slv-nativeints  --slv-parallel --slv-p-cpus 4 --slv-timeout 10 --slv-synth MINI ../gram.sk 2>err 1>useful # checking for satisfiablity
                    #working
			        sketch  -p cleanup  --bnd-int-range 1000 --slv-parallel --fe-output-code --slv-p-cpus 8 --slv-timeout 10 --slv-synth MINI ../gram.sk 2>err 1>useful # checking for satisfiablity

			        #sketch --slv-nativeints -p cleanup --fe-output-code --slv-timeout 10 ../gram.sk 2>&1 1>/dev/null # checking for satisfiablity
                fi
                ls gram.cpp    
			    if [ $? -ne 0 ]
			    then
				    echo "UNSAT : Cannot meet specification(this error can't be reached ) "
                    echo "Couldnot solve for second time" $Z_bv
                    exit
                fi
                
			fi
            R_bv=$(( R_bv | Z_bv ))
            cp gram.cpp ../log/$Z_bv.cpp
            
            for i in "${fun_to_syn[@]}";
            do
                iter=0
                for j in "${fun_map_list[@]}"; 
                do
                    if [ $i == $j ]
                    then 
                          break
                    fi
                    iter=$(( iter + 1 ))
                done
                fun="${fun_name_list[$iter]}"
		        echo "fun " $fun

                bash ../../getFunDef.sh gram.cpp $fun > ./isEmpty

                emFlag=$( wc -l ./isEmpty | cut -d " " -f 1)
                
                if [ $emFlag == 0 ];
                then 
                    echo "gotcha $fun"
                    #continue
                    exit
                fi

                if [ $emFlag != 0 ]
                then
                    cat ./isEmpty > fun_holes_dir/$i.cpp
                    bash ../../getFunDef.sh useful $fun > fun_holes_dir/$i.sk

                    cp fun_holes_dir/$i.sk hihi
                    sed -i -e   's/, ref global int\[2\] pc__ANONYMOUS_s[0-9]*//g' fun_holes_dir/$i.sk
                    sed -i -e   's/, ref global int\[20\]\[40\]\[1\] state__ANONYMOUS_s[0-9]*//g'  fun_holes_dir/$i.sk
                fi
            done
		
			cd ../../ # main directory
			duration=$(echo "$(date +%s.%N) - $inp_time_start" | bc) # end time of step L_AB
            echo "$i $duration" >> results_$run
            echo $i" ," $duration


		#exit # for debugging java bytecode 
		echo "==========================================================================================================================="
		echo "==========================================================================================================================="
	done < "$input_seed_path"
    
    mkdir synthesized_sols 2>&1 >/dev/null
    cp  syn/gen_sketch/fun_holes_dir/*.sk synthesized_sols/
    
    synth_time=$(echo "$(date +%s.%N) - $synth_time_start" | bc)
    total=$(echo "$(date +%s.%N) - $total_time_start" | bc)
    #echo "total_time  $total" >> results_$run
    echo "~~~~~~~~~~~~~~~~~~ Results ~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "example: $derivation_time, synth: $synth_time, total_time:  $total,  cex:  $CEX_num"
done

