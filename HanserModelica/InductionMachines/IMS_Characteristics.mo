within HanserModelica.InductionMachines;
model IMS_Characteristics "Characteristic curves of induction machine with slip rings"
  extends Modelica.Icons.Example;
  import Modelica.Constants.pi;
  parameter Integer m=3 "Number of stator phases";
  parameter Integer mr=3 "Number of rotor phases";
  parameter Modelica.SIunits.Voltage VsNominal=100
    "Nominal RMS voltage per phase";
  parameter Modelica.SIunits.Frequency fNominal=imsData.fsNominal "Nominal frequency";
  parameter Modelica.SIunits.Resistance Rr=0.16/imsData.turnsRatio^2 "Starting resistance";
  parameter Integer p=imsData.p "Number of pole pairs";
  parameter Modelica.SIunits.AngularVelocity w_Load(displayUnit="rev/min")=
       Modelica.SIunits.Conversions.from_rpm(1440.45)
    "Nominal load speed";
  Real speedPerUnit = p*imsQS.wMechanical/(2*pi*fNominal) "Per unit speed";
  Real slip = 1-speedPerUnit "Slip";
  output Modelica.SIunits.Current Iqs=iSensorQS.I "QS RMS current";
  Modelica.Magnetic.QuasiStatic.FundamentalWave.Utilities.MultiTerminalBox terminalBoxQS(m=m, terminalConnection="Y") annotation (Placement(transformation(extent={{20,46},{40,66}})));
  Modelica.Magnetic.QuasiStatic.FundamentalWave.BasicMachines.InductionMachines.IM_SlipRing imsQS(
    p=imsData.p,
    fsNominal=imsData.fsNominal,
    TsRef=imsData.TsRef,
    alpha20s(displayUnit="1/K") = imsData.alpha20s,
    Jr=imsData.Jr,
    Js=imsData.Js,
    frictionParameters=imsData.frictionParameters,
    statorCoreParameters=imsData.statorCoreParameters,
    strayLoadParameters=imsData.strayLoadParameters,
    TrRef=imsData.TrRef,
    alpha20r(displayUnit="1/K") = imsData.alpha20r,
    useTurnsRatio=imsData.useTurnsRatio,
    VsNominal=imsData.VsNominal,
    VrLockedRotor=imsData.VrLockedRotor,
    rotorCoreParameters=imsData.rotorCoreParameters,
    Rs=imsData.Rs*m/3,
    Lssigma=imsData.Lssigma*m/3,
    Lm=imsData.Lm*m/3,
    gammar(fixed=true, start=pi/2),
    TurnsRatio=imsData.turnsRatio,
    Lrsigma=imsData.Lrsigma*mr/3,
    Rr=imsData.Rr*mr/3,
    mr=mr,
    m=m,
    TsOperational=373.15,
    effectiveStatorTurns=imsData.effectiveStatorTurns,
    TrOperational=373.15)
                         annotation (Placement(transformation(extent={{20,30},{40,50}})));
  parameter
    MoveTo_MSL.Electrical.Machines.Utilities.ParameterRecords.AIM_SlipRingData
    imsData(
    effectiveStatorTurns=64,
    TsRef=373.15,
    TrRef=373.15)
            "Machine data"
    annotation (Placement(transformation(extent={{70,72},{90,92}})));
  Modelica.Electrical.QuasiStationary.MultiPhase.Sources.VoltageSource vSourceQS(
    m=m,
    phi=-Modelica.Electrical.MultiPhase.Functions.symmetricOrientation(m),
    f=fNominal,
    V=fill(VsNominal, m)) annotation (Placement(transformation(
        origin={-80,60},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Modelica.Electrical.QuasiStationary.MultiPhase.Basic.Star starQS(m=m)
    annotation (Placement(transformation(
        origin={-80,30},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground groundQS
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-80,10})));
  Modelica.Electrical.QuasiStationary.MultiPhase.Sensors.PowerSensor pSensorQS(m=m) annotation (Placement(transformation(extent={{-70,70},{-50,90}})));
  Modelica.Electrical.QuasiStationary.MultiPhase.Sensors.CurrentQuasiRMSSensor iSensorQS(m=m) annotation (Placement(transformation(extent={{-10,70},{10,90}})));
  Modelica.Electrical.QuasiStationary.MultiPhase.Basic.Star
    starMachineQS(m=
        Modelica.Electrical.MultiPhase.Functions.numberOfSymmetricBaseSystems(
                                                                     m))
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-40,30})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground
    groundMachineQS annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={-40,10})));

  Modelica.Mechanics.Rotational.Sources.Speed speed(exact=true) annotation (Placement(transformation(extent={{70,30},{50,50}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=3*2*pi*fNominal/p,
    duration=1,
    offset=-2*pi*fNominal/p) annotation (Placement(transformation(extent={{100,30},{80,50}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground groundRotorQS annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-10,10})));
  Modelica.Electrical.QuasiStationary.MultiPhase.Basic.Star starRotorQS(m=mr) annotation (Placement(transformation(
        origin={-10,30},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Modelica.Electrical.QuasiStationary.MultiPhase.Basic.Resistor resistor(m=mr, R_ref=fill(Rr, mr)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={10,36})));
equation
  connect(terminalBoxQS.plug_sn, imsQS.plug_sn)
    annotation (Line(points={{24,50},{24,50}}, color={0,0,255}));
  connect(terminalBoxQS.plug_sp, imsQS.plug_sp)
    annotation (Line(points={{36,50},{36,50}}, color={0,0,255}));
  connect(groundQS.pin, starQS.pin_n)
    annotation (Line(points={{-80,20},{-80,20}}, color={85,170,255}));
  connect(starQS.plug_p, vSourceQS.plug_n) annotation (Line(points={{-80,40},{-80,50}}, color={85,170,255}));
  connect(pSensorQS.currentN, iSensorQS.plug_p) annotation (Line(points={{-50,80},{-10,80}}, color={85,170,255}));
  connect(pSensorQS.voltageP, pSensorQS.currentP) annotation (Line(points={{-60,90},{-70,90},{-70,80}}, color={85,170,255}));
  connect(pSensorQS.voltageN, starQS.plug_p) annotation (Line(points={{-60,70},{-60,40},{-80,40}}, color={85,170,255}));
  connect(iSensorQS.plug_n, terminalBoxQS.plugSupply) annotation (Line(points={{10,80},{30,80},{30,52}}, color={85,170,255}));
  connect(starMachineQS.pin_n, groundMachineQS.pin) annotation (Line(
      points={{-40,20},{-40,20}},
      color={85,170,255}));
  connect(starMachineQS.plug_p, terminalBoxQS.starpoint) annotation (
      Line(
      points={{-40,40},{-40,52},{20,52}},
      color={85,170,255}));
  connect(vSourceQS.plug_p, pSensorQS.currentP) annotation (Line(points={{-80,70},{-80,80},{-70,80}}, color={85,170,255}));
  connect(ramp.y,speed. w_ref) annotation (Line(points={{79,40},{72,40}}, color={0,0,127}));
  connect(imsQS.flange, speed.flange) annotation (Line(points={{40,40},{50,40}}, color={0,0,0}));
  connect(starRotorQS.pin_n, groundRotorQS.pin) annotation (Line(points={{-10,20},{-10,20}}, color={85,170,255}));
  connect(resistor.plug_n, imsQS.plug_rn) annotation (Line(points={{10,26},{20,26},{20,34}}, color={85,170,255}));
  connect(imsQS.plug_rp, resistor.plug_p) annotation (Line(points={{20,46},{10,46}}, color={85,170,255}));
  connect(starRotorQS.plug_p, resistor.plug_n) annotation (Line(points={{-10,40},{-10,46},{2,46},{2,26},{10,26}}, color={85,170,255}));
  annotation (
    experiment(Interval=0.001, StopTime=1, Tolerance=1e-06),
    Documentation(info="<html>

<p>
This examples allows the investigation of characteristic curves of quasi static multi phase induction machines with slip ring rotor 
as a function of rotor speed.
</p>

<p>
Simulate for 1 second and plot (versus imsQS.wMechanical or perUnitSpeed):
</p>

<ul>
<li><code>currentSensorQS.abs_i[1]</code>: (equivalent) RMS stator current</li>
<li><code>imsQS.tauElectrical</code>: machine torque</li>
<li><code>imscQS.powerBalance.powerStator</code>: stator power</li>
<li><code>imsQS.powerBalance.powerMechanical</code>: mechanical power</li>
</ul>
<p>Default machine parameters are used. The rotor resistance may be varied to demonstrate the impact on the characteristic curves</p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                         graphics={         Text(
                  extent={{20,8},{100,0}},
                  lineColor={0,0,0},
                  fillColor={255,255,170},
                  fillPattern=FillPattern.Solid,
                  textStyle={TextStyle.Bold},
          textString="%m phase quasi static")}));
end IMS_Characteristics;
