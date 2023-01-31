create_dev_seed()
{   
    #just sort the output of crest
    #cat terms | sort > t
    #sort by string lengths and donot allow length less than 2
    awk 'length($0) > 2 { print length,  $0 }'  terms | sort -n | cut -d' ' -f2- > t
    mv t terms > /dev/null 2>&1


    mkdir dev_seed_in > /dev/null 2>&1
    rm dev_seed_in/* > /dev/null 2>&1

    while IFS= read -r line;
    do
        echo "$line" > dump
        perl -pe 's{NUM}{ sprintf "%d",  int(3*rand()+1 ) }ge' dump > dmp
        mv dmp dump
        rm ./getDerivation  > /dev/null 2>&1

        ../gram_oracle < dump

        derivationList=()

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

        for i in 1 #2 3 4 5
        do
            echo "$line" >> dev_seed_in/$devCode
        done
    done < terms
}

rm terms
bash run.sh  > /dev/null 2>&1
create_dev_seed
rm -r ../../input/dev_seed_in
cp -r dev_seed_in ../../input/
