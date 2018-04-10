*** FULLADDER PT BY MAHDI SHARIFI 961001 *****

.INCLUDE "65nm_bulk.pm"
.INCLUDE "fa_pt_gates_modules.LIB"

.TRAN	TT	STOP
*--------------------------------------------------------------------------
VDD		VDD		0	VMAX
.PARAM	VMAX=1V	LMIN=65N	WMIN=65N	AR=2.5	PW=200P		TT=10P
.PARAM Vdd2='VMAX/2'
.PARAM STOP='9*PW+10*TT'

XSUM_PT		A	A_BAR	B	B_BAR		C	C_BAR  VDD	SUM	  SUM_BAR SUM_PT
XMAJORITY 	A	A_BAR	B	B_BAR		C	C_BAR  VDD	COUT COUT_BAR MAJORITY

*------- Load capacitance -------------------------
Cl OUT 0 0.1p
.OPTIONS PROBE POST MEASOUT
.PROBE	V(A) V(B) V(c) V(Sum) V(Cout)
*-------------------------SIGNALS--------------------------------
VA		A		    0  	PULSE	0		VMAX	PW		 	TT	TT	PW			'2*PW+2*TT'
VA_BAR 	A_BAR		0	PULSE	VMAX	0		PW		 	TT	TT	PW			'2*PW+2*TT'

VB		B	    	0	PULSE	0		VMAX	'2*PW+TT'	TT	TT	'2*PW+TT'	'4*PW+4*TT'
VB_BAR	B_BAR		0	PULSE	VMAX	0		'2*PW+TT'	TT	TT	'2*PW+TT'	'4*PW+4*TT'

VM		C		    0	PULSE	0		VMAX	'4*PW+3*TT'	TT	TT	'4*PW+3*TT'	'8*PW+8*TT'
VM_BAR	C_BAR		0	PULSE	VMAX	0		'4*PW+3*TT'	TT	TT	'4*PW+3*TT'	'8*PW+8*TT'

*-------------------------Rise, Fall, and Delay---------------------------------
	*---------------------- SUM ----------------------------------
.MEASURE TRAN t1 TRIG V(A) VAL=Vdd2 RISE=1 TARG V(sum ) VAL=Vdd2 rise=1
.MEASURE TRAN t2 TRIG V(C) VAL=Vdd2 RISE=1 TARG V(sum ) VAL=Vdd2 rise=2
.MEASURE TRAN t3 TRIG V(A) VAL=Vdd2 RISE=4 TARG V(sum ) VAL=Vdd2 rise=3

.MEASURE TRAN tplh1_sum  PARAM='max(t1,t2)'
.MEASURE TRAN tplh_sum  PARAM='max(tplh1_sum ,t3)'

.MEASURE TRAN g1 TRIG V(A) VAL=Vdd2 RISE=2 TARG V(sum ) VAL=Vdd2 fall=1
.MEASURE TRAN g2 TRIG V(A) VAL=Vdd2 RISE=3 TARG V(sum ) VAL=Vdd2 fall=2
.MEASURE TRAN g3 TRIG V(B) VAL=Vdd2 FALL=2 TARG V(sum ) VAL=Vdd2 fall=3

.MEASURE TRAN tphl1_sum  PARAM='max(g1,g2)'
.MEASURE TRAN tphl_sum  PARAM='max(tphl1_sum ,g3)'


.MEASURE TRAN tp_sum PARAM='max(tplh_sum ,tphl_sum )'
	*---------------------- CARRY -----------------
.MEASURE TRAN tc1 TRIG V(A) VAL=Vdd2 RISE=1 TARG V(COUT ) VAL=Vdd2 rise=1
.MEASURE TRAN tc2 TRIG V(A) VAL=Vdd2 RISE=3 TARG V(COUT ) VAL=Vdd2 rise=2

.MEASURE TRAN tcphl1_carry  PARAM='max(tc1,tc2)'
.MEASURE TRAN tplh_carry  PARAM='max(tcphl1_carry ,-1)'

.MEASURE TRAN gc1 TRIG V(C) VAL=Vdd2 RISE=1 TARG V(sum ) VAL=Vdd2 fall=1
.MEASURE TRAN gc2 TRIG V(B) VAL=Vdd2 FALL=2 TARG V(sum ) VAL=Vdd2 fall=2

.MEASURE TRAN tphl_carry  PARAM='max(gc1,gc2)'

.MEASURE TRAN tp_carry PARAM='max(tplh_carry ,tphl_carry )'
	*-------------- SUM VS CARRY ------------
.MEASURE TRAN tp_totla PARAM='max(tp_sum ,tp_carry )'

*-------------------------POWER---------------------------------
*.MEASURE TRAN pow AVG POWER FROM=0n TO=STOP
*.MEASURE TRAN pdp PARAM='tp_totla*pow'

.END

