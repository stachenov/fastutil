#!/bin/sh

TYPE=(boolean byte short int long char float double Object Object)
PACKAGE=(booleans bytes shorts ints longs chars floats doubles objects objects)
TYPE_CAP=(Boolean Byte Short Int Long Char Float Double Object Reference)
CLASS=(Boolean Byte Short Integer Long Character Float Double Object Reference)

lf=".75"

if [ "$1" != "" ]; then lf=$1; fi

for ((t=1; t<10000; t*=10)); do

    SET=(OpenHashSet LinkedOpenHashSet RBTreeSet AVLTreeSet)

    for ((f=0; f<${#SET[*]}; f++)); do
	l=${#TYPE[*]}
	if [[ ${SET[$f]} != "OpenHashSet" && ${SET[$f]} != "LinkedOpenHashSet" ]]; then l=$((l-1)); fi # Only hash sets may have reference keys.
	for ((k=1; k<l; k++)); do
		CLASSNAME=it.unimi.dsi.fastutil.${PACKAGE[$k]}.${TYPE_CAP[$k]}${SET[$f]}
		if [[ $f < 2 ]]; then
			echo "Testing $CLASSNAME ($t elements, load factor $lf)..."
			java -ea -server $CLASSNAME test $t $lf
		else
			echo "Testing $CLASSNAME ($t elements)..."
			java -ea -server $CLASSNAME test $t
		fi
	done
    done

    MAP=(OpenHashMap LinkedOpenHashMap RBTreeMap AVLTreeMap)

    for ((f=0; f<${#MAP[*]}; f++)); do
	l=${#TYPE[*]}
	if [[ ${MAP[$f]} != "OpenHashMap" && ${MAP[$f]} != "LinkedOpenHashMap" ]]; then l=$((l-1)); fi # Only hash maps may have reference keys.
	for ((k=1; k<l; k++)); do
	    for ((v=1; v<${#TYPE[*]}; v++)); do
		CLASSNAME=it.unimi.dsi.fastutil.${PACKAGE[$k]}.${TYPE_CAP[$k]}2${TYPE_CAP[$v]}${MAP[$f]}
		if [[ $f < 2 ]]; then
			echo "Testing $CLASSNAME ($t elements, load factor $lf)..."
			java -ea -server $CLASSNAME test $t $lf
		else
			echo "Testing $CLASSNAME ($t elements)..."
			java -ea -server $CLASSNAME test $t
		fi
	    done
	done
    done

    LIST=(ArrayList)

    for ((f=0; f<${#LIST[*]}; f++)); do
	l=${#TYPE[*]}
	for ((k=1; k<l; k++)); do
		CLASSNAME=it.unimi.dsi.fastutil.${PACKAGE[$k]}.${TYPE_CAP[$k]}${LIST[$f]}
		echo "Testing $CLASSNAME ($t elements)..."
		java -ea -server $CLASSNAME test $t
	done
    done

    QUEUE=(HeapPriorityQueue HeapSemiIndirectPriorityQueue ArrayIndirectPriorityQueue HeapIndirectPriorityQueue HeapSesquiIndirectDoublePriorityQueue ArraySesquiIndirectDoublePriorityQueue)

    for ((f=0; f<${#QUEUE[*]}; f++)); do
	l=${#TYPE[*]}
	for ((k=1; k<l-1; k++)); do
		CLASSNAME=it.unimi.dsi.fastutil.${PACKAGE[$k]}.${TYPE_CAP[$k]}${QUEUE[$f]}
		echo "Testing $CLASSNAME ($t elements)..."
		java -ea -server $CLASSNAME test $t
	done
    done

    STATIC=(Sets Lists)

    for ((f=0; f<${#STATIC[*]}; f++)); do
	l=${#TYPE[*]}
	for ((k=0; k<l; k++)); do
		if [[ ${STATIC[$f]} == "SortedSets" && $k == 0 ]]; then k=1; fi
		CLASSNAME=it.unimi.dsi.fastutil.${PACKAGE[$k]}.${TYPE_CAP[$k]}${STATIC[$f]}
		echo "Testing ${TYPE_CAP[$k]} ${STATIC[$f]} singleton..."
		java -ea -server $CLASSNAME ${TYPE_CAP[$k]}
	done
    done

    STATIC=(SortedSets)

    for ((f=0; f<${#STATIC[*]}; f++)); do
	l=${#TYPE[*]}
	for ((k=1; k<l-1; k++)); do
		if [[ ${STATIC[$f]} == "SortedSets" && $k == 0 ]]; then k=1; fi
		CLASSNAME=it.unimi.dsi.fastutil.${PACKAGE[$k]}.${TYPE_CAP[$k]}${STATIC[$f]}
		echo "Testing ${TYPE_CAP[$k]} ${STATIC[$f]} singleton..."
		java -ea -server $CLASSNAME ${TYPE_CAP[$k]}
	done
    done

    STATIC=(SortedMaps)

    for ((f=0; f<${#STATIC[*]}; f++)); do
	l=${#TYPE[*]}
	for ((k=1; k<l-1; k++)); do
	    for ((v=1; v<${#TYPE[*]}; v++)); do
		CLASSNAME=it.unimi.dsi.fastutil.${PACKAGE[$k]}.${TYPE_CAP[$k]}2${TYPE_CAP[$v]}${STATIC[$f]}
		echo "Testing ${TYPE_CAP[$k]} ${STATIC[$f]} singleton..."
		java -ea -server $CLASSNAME ${TYPE_CAP[$k]}
	    done
	done
    done

    FRONT=(ArrayFrontCodedList)

    for ((f=0; f<${#FRONT[*]}; f++)); do
	l=${#TYPE[*]}
	for ((k=1; k<6; k++)); do
		CLASSNAME=it.unimi.dsi.fastutil.${PACKAGE[$k]}.${TYPE_CAP[$k]}${FRONT[$f]}
		echo "Testing $CLASSNAME ($t elements)..."
		java -ea -server $CLASSNAME test $t
	done
    done
done
