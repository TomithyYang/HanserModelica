within HanserModelica.MoveTo_Modelica.Electrical.MultiPhase.Sensors;
model MultiSensor "Multiphase sensor to measure current, voltage and power"
  extends Modelica.Icons.RotationalSensor;
  parameter Integer m(min=1) = 3 "Number of phases";
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug pc(final m=m)
      "Positive plug, current path"
    annotation (Placement(transformation(extent={{-90,-10},{-110,10}})));
  Modelica.Electrical.MultiPhase.Interfaces.NegativePlug nc(final m=m)
      "Negative plug, current path"
    annotation (Placement(transformation(extent={{110,-10},{90,10}})));
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug pv(final m=m)
      "Positive plug, voltage path"
    annotation (Placement(transformation(extent={{-10,110},{10,90}})));
  Modelica.Electrical.MultiPhase.Interfaces.NegativePlug nv(final m=m)
      "Negative plug, voltage path"
    annotation (Placement(transformation(extent={{10,-110},{-10,-90}})));
  Modelica.Blocks.Interfaces.RealOutput i[m](each final quantity="ElectricCurrent", each final unit="A")
    "Current as output signal" annotation (Placement(transformation(
        origin={-60,-110},
        extent={{10,10},{-10,-10}},
        rotation=90)));
  Modelica.Blocks.Interfaces.RealOutput v[m](each final quantity="ElectricPotential", each final unit="V")
    "Voltage as output signal" annotation (Placement(transformation(
        origin={60,-110},
        extent={{10,10},{-10,-10}},
        rotation=90)));
  Modelica.Blocks.Interfaces.RealOutput power[m](each final quantity="Power", each final unit="W")
    "Instantaneous power as output signal" annotation (Placement(transformation(
        origin={-110,-60},
        extent={{-10,10},{10,-10}},
        rotation=180)));
  Modelica.Blocks.Interfaces.RealOutput powerTotal(final quantity="Power", final unit="W")
    "Sum of instantaneous power as output signal" annotation (Placement(transformation(
        origin={110,-60},
        extent={{10,10},{-10,-10}},
        rotation=180)));
equation
  pc.pin.i + nc.pin.i = zeros(m);
  pc.pin.v - nc.pin.v = zeros(m);
  pv.pin.i = zeros(m);
  nv.pin.i = zeros(m);
  i = pc.pin.i;
  v = pv.pin.v - nv.pin.v;
  power = v.*i;
  powerTotal = sum(power);
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
      Line(points = {{0,100},{0,70}}, color = {0,0,255}),
      Line(points = {{0,-70},{0,-100}}, color = {0,0,255}),
      Line(points = {{-100,0},{100,0}}, color = {0,0,255}),
      Line(points = {{0,70},{0,40}}),
        Line(points={{-100,-60},{-80,-60},{-56,-42}},
                                                   color={28,108,200}),
        Line(points={{-60,-100},{-60,-80},{-42,-56}},
                                                   color={28,108,200}),
        Line(points={{60,-100},{60,-80},{42,-56}},
                                                color={28,108,200}),
        Text(
          extent={{-100,-40},{-60,-80}},
          textString="p"),
        Text(
          extent={{-80,-60},{-40,-100}},
          textString="i"),
        Text(
          extent={{40,-60},{80,-100}},
          textString="v"),
        Line(points={{100,-60},{80,-60},{56,-42}}, color={28,108,200}),
        Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          lineColor={0,0,255})}),
    Documentation(info="<html>
<p>This multi sensor measures currents, voltages and instantaneous electrical power of a multiphase system and has separated voltage and current paths.
The plugs of the voltage paths are pv and nv, the plugs of the current paths are pc and nc.
The internal resistance of each current path is zero, the internal resistance of each voltage path is infinite.</p>
</html>", revisions="<html>
<ul>
<li><em>20170306</em> first implementation by Anton Haumer</li>
</ul>
</html>"));
end MultiSensor;
