within HanserModelica.InductionMachines;
model IMS_Characteristics2 "Characteristic curves of induction machine with slip rings and Rr'=0.16"
  extends HanserModelica.InductionMachines.IMS_Characteristics1(Rr=0.16/imsData.turnsRatio^2);
end IMS_Characteristics2;
