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


%web_open_table(WORK.RollerCoasterDataRATINGS);


proc corr data=WORK.RollerCoasterDataRATINGS nomiss plots=matrix;
   var Rating Length Duration Drop Num_of_Inversions Max_Height_n Top_Speed ;
 run;


*FULL MODEL;
Proc Reg data=WORK.RollerCoasterDataRATINGS;
	Model Rating = Length Duration Drop Num_of_Inversions Max_Height_n Top_Speed / vif; /* r gets the residuals and Cook's D. r is not correlation here. */
run;
*Adj R-Sq	0.0329;


*DROPPING LENGTH AS IT HAS THE HIGHEST P-VALUE AND IS VERY RELATED TO DROP, MAX_HEIGHT, TOP_SPEED;
Proc Reg data=WORK.RollerCoasterDataRATINGS;
	Model Rating = Duration Drop Num_of_Inversions Max_Height_n Top_Speed / vif; /* r gets the residuals and Cook's D. r is not correlation here. */
run;
*Adj R-Sq	0.0453;


*DROP, MAX_HEIGHT, TOP_SPEED are correlated from proc cor above and the vifs are high
-- least interested in Max_Height - dropped max_height_n;
Proc Reg data=WORK.RollerCoasterDataRATINGS;
	Model Rating = Duration Drop Num_of_Inversions Top_Speed / vif; /* r gets the residuals and Cook's D. r is not correlation here. */
run;
*Adj R-Sq	0.0691;


*Dropping drop as it has high p-value and is correlated with Top_Speed 
-- dropped Drop;
*Conclusion: Top_Speed is the best predictor by far;
Proc Reg data=WORK.RollerCoasterDataRATINGS;
	Model Rating = Duration Num_of_Inversions Top_Speed / vif; /* r gets the residuals and Cook's D. r is not correlation here. */
run;
*Adj R-Sq	0.0953;
*POSSIBLE BEST MODEL;

*SWAPPING TOP_SPEED FOR DROP;
Proc Reg data=WORK.RollerCoasterDataRATINGS;
	Model Rating = Duration Num_of_Inversions Drop / vif; /* r gets the residuals and Cook's D. r is not correlation here. */
run;
*Adj R-Sq	0.0536;

*SWAPPING TOP_SPEED FOR MAX_HEIGHT;
Proc Reg data=WORK.RollerCoasterDataRATINGS;
	Model Rating = Duration Num_of_Inversions Max_Height_n / vif; /* r gets the residuals and Cook's D. r is not correlation here. */
run;
*Adj R-Sq	0.0364;

*CONCLUSION: Thus out of max_ehight, drop, and top_speed - top_speed is the best predictor;

*SWAPPING DURATION FOR LENGTH;
Proc Reg data=WORK.RollerCoasterDataRATINGS;
	Model Rating = Length Num_of_Inversions Top_Speed / vif; /* r gets the residuals and Cook's D. r is not correlation here. */
run;
*Adj R-Sq	0.1240;
*CONCLUSION: Out of Drop and Length - Length is the better predictor
*NOTE: Considered swapping out number of inverions but it is not corealted with anything;






*Drop no_of_Inversions as it is the highest p-value;
Proc Reg data=WORK.RollerCoasterDataRATINGS;
	Model Rating = Duration Top_Speed / vif; /* r gets the residuals and Cook's D. r is not correlation here. */
run;
*Adj R-Sq	0.0917	;
*POSSIBLE BEST MODEL;

*Drop Duration;
Proc Reg data=WORK.RollerCoasterDataRATINGS;
	Model Rating = Top_Speed / vif; /* r gets the residuals and Cook's D. r is not correlation here. */
run;
*Adj R-Sq	0.0756;
