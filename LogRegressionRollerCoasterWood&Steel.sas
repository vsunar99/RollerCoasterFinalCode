/* Generated Code (IMPORT) */
/* Source File: RollerCoasterDataRATINGS.xlsx */
/* Source Path: /home/u49265891/STAT3130Fall'21 */
/* Code generated on: 10/7/22, 10:17 AM */

%web_drop_table(WORK.RollerCoasterDataRATINGS);


FILENAME REFFILE '/home/u49265891/STAT3130Fall''21/RollerCoasterDataRATINGS.xlsx';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=WORK.RollerCoasterDataRATINGS;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.RollerCoasterDataRATINGS; RUN;

/*Changing Max_Height to be quantitative*/
data work.RollerCoasterDataRATINGS;
set work.RollerCoasterDataRATINGS;
Max_Height_n = Max_Height*1;
run;

*MLR;
/*Running regression to get the vifs*/
Proc Reg data=WORK.RollerCoasterDataRATINGS;
	Model Duration = Length Drop Num_of_Inversions Max_Height_n Top_Speed / vif; /* r gets the residuals and Cook's D. r is not correlation here. */
run;

/*After dropping Max_Height*/
Proc Reg data=WORK.RollerCoasterDataRATINGS;
	Model Duration = Length Drop Num_of_Inversions Top_Speed / vif; /* r gets the residuals and Cook's D. r is not correlation here. */
run;





/**********************************Logistic Regression**************************/
/*HYP 3: Is there a relationship between the roller coaster type (E) and duration (L),
length(K), drop (J), number of inversions (N), maximum height 
(I), top speed (H) and design (F)?*/
Proc hplogistic data=WORK.RollerCoasterDataRATINGS;
class design;
model Type= Duration Length Drop Num_of_Inversions Top_Speed Design;
run;

/*After dropping design*/
Proc hplogistic data=WORK.RollerCoasterDataRATINGS;
model Type= Duration Length Drop Num_of_Inversions Top_Speed ;
run;
*BEST LOGISTIC MODEL TO PREDICT WOOD AND STEEL
-- has infinite degrees of freedom to change this specify that the degrees of freedom
is specified by the residul in the next run;


Proc hplogistic data=WORK.RollerCoasterDataRATINGS;
model Type= Duration Length Drop Num_of_Inversions Top_Speed / association DDFM=residual;
run;

*ROC Curve;
/*fit logistic regression model & create ROC curve*/
proc logistic data=WORK.RollerCoasterDataRATINGS descending plots(only)=roc;
  model Type= Duration Length Drop Num_of_Inversions Top_Speed;
run;


*BEST LOGISTIC MODEL TO PREDICT WOOD AND STEEL;
