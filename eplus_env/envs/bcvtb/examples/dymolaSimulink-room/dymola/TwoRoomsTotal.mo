package ModelicaServices
  "(version = 3.2.1, target = \"Dymola\") Models and functions used in the Modelica Standard Library requiring a tool specific implementation"

package Machine

  final constant Real eps=1.e-15 "Biggest number such that 1.0 + eps = 1.0";

  final constant Real inf=1.e+60
  "Biggest Real number such that inf and -inf are representable on the machine";
  annotation (Documentation(info="<html>
<p>
Package in which processor specific constants are defined that are needed
by numerical algorithms. Typically these constants are not directly used,
but indirectly via the alias definition in
<a href=\"modelica://Modelica.Constants\">Modelica.Constants</a>.
</p>
</html>"));
end Machine;
annotation (
  Protection(access=Access.hide),
  preferredView="info",
  version="3.2.1",
  versionDate="2013-01-17",
  versionBuild=1,
  uses(Modelica(version="3.2.1")),
  conversion(
    noneFromVersion="1.0",
    noneFromVersion="1.1",
    noneFromVersion="1.2"),
  Documentation(info="<html>
<p>
This package contains a set of functions and models to be used in the
Modelica Standard Library that requires a tool specific implementation.
These are:
</p>

<ul>
<li> <a href=\"modelica://ModelicaServices.Animation.Shape\">Shape</a>
     provides a 3-dim. visualization of elementary
     mechanical objects. It is used in
<a href=\"modelica://Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape\">Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape</a>
     via inheritance.</li>

<li> <a href=\"modelica://ModelicaServices.Animation.Surface\">Surface</a>
     provides a 3-dim. visualization of
     moveable parameterized surface. It is used in
<a href=\"modelica://Modelica.Mechanics.MultiBody.Visualizers.Advanced.Surface\">Modelica.Mechanics.MultiBody.Visualizers.Advanced.Surface</a>
     via inheritance.</li>

<li> <a href=\"modelica://ModelicaServices.ExternalReferences.loadResource\">loadResource</a>
     provides a function to return the absolute path name of an URI or a local file name. It is used in
<a href=\"modelica://Modelica.Utilities.Files.loadResource\">Modelica.Utilities.Files.loadResource</a>
     via inheritance.</li>

<li> <a href=\"modelica://ModelicaServices.Machine\">ModelicaServices.Machine</a>
     provides a package of machine constants. It is used in
<a href=\"modelica://Modelica.Constants\">Modelica.Constants</a>.</li>

<li> <a href=\"modelica://ModelicaServices.Types.SolverMethod\">Types.SolverMethod</a>
     provides a string defining the integration method to solve differential equations in
     a clocked discretized continuous-time partition (see Modelica 3.3 language specification).
     It is not yet used in the Modelica Standard Library, but in the Modelica_Synchronous library
     that provides convenience blocks for the clock operators of Modelica version &ge; 3.3.</li>
</ul>

<p>
This implementation is targeted for Dymola.
</p>

<p>
<b>Licensed by DLR and Dassault Syst&egrave;mes AB under the Modelica License 2</b><br>
Copyright &copy; 2009-2013, DLR and Dassault Syst&egrave;mes AB.
</p>

<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\"> http://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>

</html>"));
end ModelicaServices;

package Modelica "Modelica Standard Library - Version 3.2.1 (Build 2)"
extends Modelica.Icons.Package;

package Utilities
    "Library of utility functions dedicated to scripting (operating on files, streams, strings, system)"
    extends Modelica.Icons.Package;

    package Strings "Operations on strings"
      extends Modelica.Icons.Package;

      function compare "Compare two strings lexicographically"
        //extends Modelica.Icons.Function;
        input String string1;
        input String string2;
        input Boolean caseSensitive=true
          "= false, if case of letters is ignored";
        output Modelica.Utilities.Types.Compare result "Result of comparison";
      external "C" result = ModelicaStrings_compare(string1, string2, caseSensitive);
        annotation (Library="ModelicaExternalC", Documentation(info="<html>
<h4>Syntax</h4>
<blockquote><pre>
result = Strings.<b>compare</b>(string1, string2);
result = Strings.<b>compare</b>(string1, string2, caseSensitive=true);
</pre></blockquote>
<h4>Description</h4>
<p>
Compares two strings. If the optional argument caseSensitive=false,
upper case letters are treated as if they would be lower case letters.
The result of the comparison is returned as:
</p>
<pre>
  result = Modelica.Utilities.Types.Compare.Less     // string1 &lt; string2
         = Modelica.Utilities.Types.Compare.Equal    // string1 = string2
         = Modelica.Utilities.Types.Compare.Greater  // string1 &gt; string2
</pre>
<p>
Comparison is with regards to lexicographical order,
e.g., \"a\" &lt; \"b\";
</p>
</html>"));
      end compare;

      function isEqual "Determine whether two strings are identical"
        //extends Modelica.Icons.Function;
        input String string1;
        input String string2;
        input Boolean caseSensitive=true
          "= false, if lower and upper case are ignored for the comparison";
        output Boolean identical "True, if string1 is identical to string2";
      algorithm
        identical :=compare(string1, string2, caseSensitive) == Types.Compare.Equal;
        annotation (
      Documentation(info="<html>
<h4>Syntax</h4>
<blockquote><pre>
Strings.<b>isEqual</b>(string1, string2);
Strings.<b>isEqual</b>(string1, string2, caseSensitive=true);
</pre></blockquote>
<h4>Description</h4>
<p>
Compare whether two strings are identical,
optionally ignoring case.
</p>
</html>"));
      end isEqual;
    end Strings;

    package System "Interaction with environment"
      extends Modelica.Icons.Package;

    function getEnvironmentVariable "Get content of environment variable"
      //extends Modelica.Icons.Function;
      input String name "Name of environment variable";
      input Boolean convertToSlash =  false
          "True, if native directory separators in 'result' shall be changed to '/'";
      output String content
          "Content of environment variable (empty, if not existent)";
      output Boolean exist
          "= true, if environment variable exists; = false, if it does not exist";
      external "C" ModelicaInternal_getenv(name, convertToSlash, content, exist);
        annotation (Library="ModelicaExternalC",Documentation(info="<html>

</html>"));
    end getEnvironmentVariable;
    end System;

    package Types "Type definitions used in package Modelica.Utilities"
      extends Modelica.Icons.Package;

      type Compare = enumeration(
          Less "String 1 is lexicographically less than string 2",
          Equal "String 1 is identical to string 2",
          Greater "String 1 is lexicographically greater than string 2")
        "Enumeration defining comparision of two strings";
      annotation (Documentation(info="<html>
<p>
This package contains type definitions used in Modelica.Utilities.
</p>

</html>"));
    end Types;
end Utilities;

  package Blocks
  "Library of basic input/output control blocks (continuous, discrete, logical, table blocks)"
  import SI = Modelica.SIunits;
  extends Modelica.Icons.Package;

    package Interfaces
    "Library of connectors and partial models for input/output blocks"
      import Modelica.SIunits;
      extends Modelica.Icons.InterfacesPackage;

      connector RealInput = input Real "'input Real' as connector" annotation (
        defaultComponentName="u",
        Icon(graphics={
          Polygon(
            lineColor={0,0,127},
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid,
            points={{-100.0,100.0},{100.0,0.0},{-100.0,-100.0}})},
          coordinateSystem(extent={{-100.0,-100.0},{100.0,100.0}},
            preserveAspectRatio=true,
            initialScale=0.2)),
        Diagram(
          coordinateSystem(preserveAspectRatio=true,
            initialScale=0.2,
            extent={{-100.0,-100.0},{100.0,100.0}}),
            graphics={
          Polygon(
            lineColor={0,0,127},
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid,
            points={{0.0,50.0},{100.0,0.0},{0.0,-50.0},{0.0,50.0}}),
          Text(
            lineColor={0,0,127},
            extent={{-10.0,60.0},{-10.0,85.0}},
            textString="%name")}),
        Documentation(info="<html>
<p>
Connector with one input signal of type Real.
</p>
</html>"));

      connector RealOutput = output Real "'output Real' as connector" annotation (
        defaultComponentName="y",
        Icon(
          coordinateSystem(preserveAspectRatio=true,
            extent={{-100.0,-100.0},{100.0,100.0}},
            initialScale=0.1),
            graphics={
          Polygon(
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            points={{-100.0,100.0},{100.0,0.0},{-100.0,-100.0}})}),
        Diagram(
          coordinateSystem(preserveAspectRatio=true,
            extent={{-100.0,-100.0},{100.0,100.0}},
            initialScale=0.1),
            graphics={
          Polygon(
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            points={{-100.0,50.0},{0.0,0.0},{-100.0,-50.0}}),
          Text(
            lineColor={0,0,127},
            extent={{30.0,60.0},{30.0,110.0}},
            textString="%name")}),
        Documentation(info="<html>
<p>
Connector with one output signal of type Real.
</p>
</html>"));

      partial block DiscreteBlock "Base class of discrete control blocks"
        extends Modelica.Blocks.Icons.DiscreteBlock;

        parameter SI.Time samplePeriod(min=100*Modelica.Constants.eps, start=0.1)
        "Sample period of component";
        parameter SI.Time startTime=0 "First sample time instant";
    protected
        output Boolean sampleTrigger "True, if sample time instant";
        output Boolean firstTrigger "Rising edge signals first sample instant";
      equation
        sampleTrigger = sample(startTime, samplePeriod);
        when sampleTrigger then
          firstTrigger = time <= startTime + samplePeriod/2;
        end when;
        annotation (Documentation(info="<html>
<p>
Basic definitions of a discrete block of library
Blocks.Discrete.
</p>
</html>"));
      end DiscreteBlock;
      annotation (Documentation(info="<HTML>
<p>
This package contains interface definitions for
<b>continuous</b> input/output blocks with Real,
Integer and Boolean signals. Furthermore, it contains
partial models for continuous and discrete blocks.
</p>

</html>",     revisions="<html>
<ul>
<li><i>Oct. 21, 2002</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>
       and <a href=\"http://www.robotic.dlr.de/Christian.Schweiger/\">Christian Schweiger</a>:<br>
       Added several new interfaces.
<li><i>Oct. 24, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       RealInputSignal renamed to RealInput. RealOutputSignal renamed to
       output RealOutput. GraphBlock renamed to BlockIcon. SISOreal renamed to
       SISO. SOreal renamed to SO. I2SOreal renamed to M2SO.
       SignalGenerator renamed to SignalSource. Introduced the following
       new models: MIMO, MIMOs, SVcontrol, MVcontrol, DiscreteBlockIcon,
       DiscreteBlock, DiscreteSISO, DiscreteMIMO, DiscreteMIMOs,
       BooleanBlockIcon, BooleanSISO, BooleanSignalSource, MI2BooleanMOs.</li>
<li><i>June 30, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Realized a first version, based on an existing Dymola library
       of Dieter Moormann and Hilding Elmqvist.</li>
</ul>
</html>"));
    end Interfaces;

    package Math
    "Library of Real mathematical functions as input/output blocks"
      import Modelica.SIunits;
      import Modelica.Blocks.Interfaces;
      extends Modelica.Icons.Package;

          block Gain "Output the product of a gain value with the input signal"

            parameter Real k(start=1, unit="1")
        "Gain value multiplied with input signal";
    public
            Interfaces.RealInput u "Input signal connector"
              annotation (Placement(transformation(extent={{-140,-20},{-100,20}},
                rotation=0)));
            Interfaces.RealOutput y "Output signal connector"
              annotation (Placement(transformation(extent={{100,-10},{120,10}},
                rotation=0)));

          equation
            y = k*u;
            annotation (
              Documentation(info="<html>
<p>
This block computes output <i>y</i> as
<i>product</i> of gain <i>k</i> with the
input <i>u</i>:
</p>
<pre>
    y = k * u;
</pre>

</html>"),           Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}}), graphics={
              Polygon(
                points={{-100,-100},{-100,100},{100,0},{-100,-100}},
                lineColor={0,0,127},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Text(
                extent={{-150,-140},{150,-100}},
                lineColor={0,0,0},
                textString="k=%k"),
              Text(
                extent={{-150,140},{150,100}},
                textString="%name",
                lineColor={0,0,255})}),
              Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}}), graphics={Polygon(
                points={{-100,-100},{-100,100},{100,0},{-100,-100}},
                lineColor={0,0,127},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid), Text(
                extent={{-76,38},{0,-34}},
                textString="k",
                lineColor={0,0,255})}));
          end Gain;
      annotation (
        Documentation(info="<html>
<p>
This package contains basic <b>mathematical operations</b>,
such as summation and multiplication, and basic <b>mathematical
functions</b>, such as <b>sqrt</b> and <b>sin</b>, as
input/output blocks. All blocks of this library can be either
connected with continuous blocks or with sampled-data blocks.
</p>
</html>",     revisions="<html>
<ul>
<li><i>October 21, 2002</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>
       and <a href=\"http://www.robotic.dlr.de/Christian.Schweiger/\">Christian Schweiger</a>:<br>
       New blocks added: RealToInteger, IntegerToReal, Max, Min, Edge, BooleanChange, IntegerChange.</li>
<li><i>August 7, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Realized (partly based on an existing Dymola library
       of Dieter Moormann and Hilding Elmqvist).
</li>
</ul>
</html>"),     Icon(graphics={Line(
              points={{-80,-2},{-68.7,32.2},{-61.5,51.1},{-55.1,64.4},{-49.4,72.6},
                  {-43.8,77.1},{-38.2,77.8},{-32.6,74.6},{-26.9,67.7},{-21.3,57.4},
                  {-14.9,42.1},{-6.83,19.2},{10.1,-32.8},{17.3,-52.2},{23.7,-66.2},
                  {29.3,-75.1},{35,-80.4},{40.6,-82},{46.2,-79.6},{51.9,-73.5},{
                  57.5,-63.9},{63.9,-49.2},{72,-26.8},{80,-2}},
              color={95,95,95},
              smooth=Smooth.Bezier)}));
    end Math;

    package Routing "Library of blocks to combine and extract signals"
      extends Modelica.Icons.Package;

      block Multiplex2 "Multiplexer block for two input connectors"
        extends Modelica.Blocks.Icons.Block;
        parameter Integer n1=1 "dimension of input signal connector 1";
        parameter Integer n2=1 "dimension of input signal connector 2";
        Modelica.Blocks.Interfaces.RealInput u1[n1]
        "Connector of Real input signals 1"   annotation (Placement(transformation(
                extent={{-140,40},{-100,80}}, rotation=0)));
        Modelica.Blocks.Interfaces.RealInput u2[n2]
        "Connector of Real input signals 2"   annotation (Placement(transformation(
                extent={{-140,-80},{-100,-40}}, rotation=0)));
        Modelica.Blocks.Interfaces.RealOutput y[n1 + n2]
        "Connector of Real output signals"   annotation (Placement(transformation(
                extent={{100,-10},{120,10}}, rotation=0)));

      equation
        [y] = [u1; u2];
        annotation (
          Documentation(info="<HTML>
<p>
The output connector is the <b>concatenation</b> of the two input connectors.
Note, that the dimensions of the input connector signals have to be
explicitly defined via parameters n1 and n2.
</p>
</html>"),       Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}}), graphics={
              Line(points={{8,0},{102,0}}, color={0,0,127}),
              Ellipse(
                extent={{-14,16},{16,-14}},
                fillColor={0,0,127},
                fillPattern=FillPattern.Solid,
                lineColor={0,0,127}),
              Line(points={{-98,60},{-60,60},{-4,6}}, color={0,0,127}),
              Line(points={{-98,-60},{-60,-60},{-4,-4}}, color={0,0,127})}),
          Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}}), graphics={
              Line(points={{-98,60},{-60,60},{-4,6}}, color={0,0,255}),
              Line(points={{-98,-60},{-60,-60},{-4,-4}}, color={0,0,255}),
              Line(points={{8,0},{102,0}}, color={0,0,255}),
              Ellipse(
                extent={{-14,16},{16,-14}},
                fillColor={0,0,255},
                fillPattern=FillPattern.Solid,
                lineColor={0,0,255})}));
      end Multiplex2;

      block DeMultiplex2 "DeMultiplexer block for two output connectors"
        extends Modelica.Blocks.Icons.Block;
        parameter Integer n1=1 "dimension of output signal connector 1";
        parameter Integer n2=1 "dimension of output signal connector 2";
        Modelica.Blocks.Interfaces.RealInput u[n1 + n2]
        "Connector of Real input signals"   annotation (Placement(transformation(
                extent={{-140,-20},{-100,20}}, rotation=0)));
        Modelica.Blocks.Interfaces.RealOutput y1[n1]
        "Connector of Real output signals 1"   annotation (Placement(transformation(
                extent={{100,50},{120,70}}, rotation=0)));
        Modelica.Blocks.Interfaces.RealOutput y2[n2]
        "Connector of Real output signals 2"   annotation (Placement(transformation(
                extent={{100,-70},{120,-50}}, rotation=0)));

      equation
        [u] = [y1; y2];
        annotation (
          Documentation(info="<HTML>
<p>
The input connector is <b>split</b> up into two output connectors.
Note, that the dimensions of the output connector signals have to be
explicitly defined via parameters n1 and n2.
</p>
</html>"),       Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}}),
            graphics={
              Line(points={{100,60},{60,60},{10,8}}, color={0,0,127}),
              Ellipse(
                extent={{-14,16},{16,-14}},
                fillColor={0,0,127},
                fillPattern=FillPattern.Solid,
                lineColor={0,0,127}),
              Line(points={{100,-60},{60,-60},{8,-8}}, color={0,0,127}),
              Line(points={{-100,0},{-6,0}}, color={0,0,127})}),
          Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}}), graphics={
              Line(points={{100,60},{60,60},{10,8}}, color={0,0,255}),
              Line(points={{100,-60},{60,-60},{8,-8}}, color={0,0,255}),
              Line(points={{-100,0},{-6,0}}, color={0,0,255}),
              Ellipse(
                extent={{-14,16},{16,-14}},
                fillColor={0,0,255},
                fillPattern=FillPattern.Solid,
                lineColor={0,0,255})}));
      end DeMultiplex2;
      annotation (Documentation(info="<html>
<p>
This package contains blocks to combine and extract signals.
</p>
</html>"),     Icon(graphics={
            Line(points={{-90,0},{4,0}}, color={95,95,95}),
            Line(points={{88,65},{48,65},{-8,0}}, color={95,95,95}),
            Line(points={{-8,0},{93,0}}, color={95,95,95}),
            Line(points={{87,-65},{48,-65},{-8,0}}, color={95,95,95})}));
    end Routing;

    package Icons "Icons for Blocks"
        extends Modelica.Icons.IconsPackage;

        partial block Block "Basic graphical layout of input/output block"

          annotation (
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                  100,100}}), graphics={Rectangle(
                extent={{-100,-100},{100,100}},
                lineColor={0,0,127},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid), Text(
                extent={{-150,150},{150,110}},
                textString="%name",
                lineColor={0,0,255})}),
          Documentation(info="<html>
<p>
Block that has only the basic icon for an input/output
block (no declarations, no equations). Most blocks
of package Modelica.Blocks inherit directly or indirectly
from this block.
</p>
</html>"));

        end Block;

        partial block DiscreteBlock
      "Graphical layout of discrete block component icon"

          annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={Rectangle(
                extent={{-100,-100},{100,100}},
                lineColor={0,0,127},
                fillColor={223,211,169},
                lineThickness=5.0,
                borderPattern=BorderPattern.Raised,
                fillPattern=FillPattern.Solid), Text(
                extent={{-150,150},{150,110}},
                textString="%name",
                lineColor={0,0,255})}),
                               Documentation(info="<html>
<p>
Block that has only the basic icon for an input/output,
discrete block (no declarations, no equations), e.g.,
from Blocks.Discrete.
</p>
</html>"));
        end DiscreteBlock;
    end Icons;
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100.0,-100.0},{100.0,100.0}}, initialScale=0.1), graphics={
        Rectangle(
          origin={0.0,35.1488},
          fillColor={255,255,255},
          extent={{-30.0,-20.1488},{30.0,20.1488}}),
        Rectangle(
          origin={0.0,-34.8512},
          fillColor={255,255,255},
          extent={{-30.0,-20.1488},{30.0,20.1488}}),
        Line(
          origin={-51.25,0.0},
          points={{21.25,-35.0},{-13.75,-35.0},{-13.75,35.0},{6.25,35.0}}),
        Polygon(
          origin={-40.0,35.0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{10.0,0.0},{-5.0,5.0},{-5.0,-5.0}}),
        Line(
          origin={51.25,0.0},
          points={{-21.25,35.0},{13.75,35.0},{13.75,-35.0},{-6.25,-35.0}}),
        Polygon(
          origin={40.0,-35.0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-10.0,0.0},{5.0,5.0},{5.0,-5.0}})}), Documentation(info="<html>
<p>
This library contains input/output blocks to build up block diagrams.
</p>

<dl>
<dt><b>Main Author:</b>
<dd><a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a><br>
    Deutsches Zentrum f&uuml;r Luft und Raumfahrt e. V. (DLR)<br>
    Oberpfaffenhofen<br>
    Postfach 1116<br>
    D-82230 Wessling<br>
    email: <A HREF=\"mailto:Martin.Otter@dlr.de\">Martin.Otter@dlr.de</A><br>
</dl>
<p>
Copyright &copy; 1998-2013, Modelica Association and DLR.
</p>
<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"https://www.modelica.org/licenses/ModelicaLicense2\"> https://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</html>",   revisions="<html>
<ul>
<li><i>June 23, 2004</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Introduced new block connectors and adapted all blocks to the new connectors.
       Included subpackages Continuous, Discrete, Logical, Nonlinear from
       package ModelicaAdditions.Blocks.
       Included subpackage ModelicaAdditions.Table in Modelica.Blocks.Sources
       and in the new package Modelica.Blocks.Tables.
       Added new blocks to Blocks.Sources and Blocks.Logical.
       </li>
<li><i>October 21, 2002</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>
       and <a href=\"http://www.robotic.dlr.de/Christian.Schweiger/\">Christian Schweiger</a>:<br>
       New subpackage Examples, additional components.
       </li>
<li><i>June 20, 2000</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a> and
       Michael Tiller:<br>
       Introduced a replaceable signal type into
       Blocks.Interfaces.RealInput/RealOutput:
<pre>
   replaceable type SignalType = Real
</pre>
       in order that the type of the signal of an input/output block
       can be changed to a physical type, for example:
<pre>
   Sine sin1(outPort(redeclare type SignalType=Modelica.SIunits.Torque))
</pre>
      </li>
<li><i>Sept. 18, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Renamed to Blocks. New subpackages Math, Nonlinear.
       Additional components in subpackages Interfaces, Continuous
       and Sources. </li>
<li><i>June 30, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Realized a first version, based on an existing Dymola library
       of Dieter Moormann and Hilding Elmqvist.</li>
</ul>
</html>"));
  end Blocks;

  package Thermal
  "Library of thermal system components to model heat transfer and simple thermo-fluid pipe flow"
    extends Modelica.Icons.Package;

    package HeatTransfer
    "Library of 1-dimensional heat transfer with lumped elements"
      extends Modelica.Icons.Package;

      package Components "Lumped thermal components"
      extends Modelica.Icons.Package;

        model HeatCapacitor "Lumped thermal element storing heat"
          parameter Modelica.SIunits.HeatCapacity C
          "Heat capacity of element (= cp*m)";
          Modelica.SIunits.Temperature T(start=293.15, displayUnit="degC")
          "Temperature of element";
          Modelica.SIunits.TemperatureSlope der_T(start=0)
          "Time derivative of temperature (= der(T))";
          Interfaces.HeatPort_a port annotation (Placement(transformation(
                origin={0,-100},
                extent={{-10,-10},{10,10}},
                rotation=90)));
        equation
          T = port.T;
          der_T = der(T);
          C*der(T) = port.Q_flow;
          annotation (
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                    100,100}}), graphics={
                Text(
                  extent={{-150,110},{150,70}},
                  textString="%name",
                  lineColor={0,0,255}),
                Polygon(
                  points={{0,67},{-20,63},{-40,57},{-52,43},{-58,35},{-68,25},{-72,
                      13},{-76,-1},{-78,-15},{-76,-31},{-76,-43},{-76,-53},{-70,-65},
                      {-64,-73},{-48,-77},{-30,-83},{-18,-83},{-2,-85},{8,-89},{22,
                      -89},{32,-87},{42,-81},{54,-75},{56,-73},{66,-61},{68,-53},{
                      70,-51},{72,-35},{76,-21},{78,-13},{78,3},{74,15},{66,25},{54,
                      33},{44,41},{36,57},{26,65},{0,67}},
                  lineColor={160,160,164},
                  fillColor={192,192,192},
                  fillPattern=FillPattern.Solid),
                Polygon(
                  points={{-58,35},{-68,25},{-72,13},{-76,-1},{-78,-15},{-76,-31},{
                      -76,-43},{-76,-53},{-70,-65},{-64,-73},{-48,-77},{-30,-83},{-18,
                      -83},{-2,-85},{8,-89},{22,-89},{32,-87},{42,-81},{54,-75},{42,
                      -77},{40,-77},{30,-79},{20,-81},{18,-81},{10,-81},{2,-77},{-12,
                      -73},{-22,-73},{-30,-71},{-40,-65},{-50,-55},{-56,-43},{-58,-35},
                      {-58,-25},{-60,-13},{-60,-5},{-60,7},{-58,17},{-56,19},{-52,
                      27},{-48,35},{-44,45},{-40,57},{-58,35}},
                  lineColor={0,0,0},
                  fillColor={160,160,164},
                  fillPattern=FillPattern.Solid),
                Text(
                  extent={{-69,7},{71,-24}},
                  lineColor={0,0,0},
                  textString="%C")}),
            Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
                    {100,100}}), graphics={
                Polygon(
                  points={{0,67},{-20,63},{-40,57},{-52,43},{-58,35},{-68,25},{-72,
                      13},{-76,-1},{-78,-15},{-76,-31},{-76,-43},{-76,-53},{-70,-65},
                      {-64,-73},{-48,-77},{-30,-83},{-18,-83},{-2,-85},{8,-89},{22,
                      -89},{32,-87},{42,-81},{54,-75},{56,-73},{66,-61},{68,-53},{
                      70,-51},{72,-35},{76,-21},{78,-13},{78,3},{74,15},{66,25},{54,
                      33},{44,41},{36,57},{26,65},{0,67}},
                  lineColor={160,160,164},
                  fillColor={192,192,192},
                  fillPattern=FillPattern.Solid),
                Polygon(
                  points={{-58,35},{-68,25},{-72,13},{-76,-1},{-78,-15},{-76,-31},{
                      -76,-43},{-76,-53},{-70,-65},{-64,-73},{-48,-77},{-30,-83},{-18,
                      -83},{-2,-85},{8,-89},{22,-89},{32,-87},{42,-81},{54,-75},{42,
                      -77},{40,-77},{30,-79},{20,-81},{18,-81},{10,-81},{2,-77},{-12,
                      -73},{-22,-73},{-30,-71},{-40,-65},{-50,-55},{-56,-43},{-58,-35},
                      {-58,-25},{-60,-13},{-60,-5},{-60,7},{-58,17},{-56,19},{-52,
                      27},{-48,35},{-44,45},{-40,57},{-58,35}},
                  lineColor={0,0,0},
                  fillColor={160,160,164},
                  fillPattern=FillPattern.Solid),
                Ellipse(
                  extent={{-6,-1},{6,-12}},
                  lineColor={255,0,0},
                  fillColor={191,0,0},
                  fillPattern=FillPattern.Solid),
                Text(
                  extent={{11,13},{50,-25}},
                  lineColor={0,0,0},
                  textString="T"),
                Line(points={{0,-12},{0,-96}}, color={255,0,0})}),
            Documentation(info="<HTML>
<p>
This is a generic model for the heat capacity of a material.
No specific geometry is assumed beyond a total volume with
uniform temperature for the entire volume.
Furthermore, it is assumed that the heat capacity
is constant (independent of temperature).
</p>
<p>
The temperature T [Kelvin] of this component is a <b>state</b>.
A default of T = 25 degree Celsius (= SIunits.Conversions.from_degC(25))
is used as start value for initialization.
This usually means that at start of integration the temperature of this
component is 25 degrees Celsius. You may, of course, define a different
temperature as start value for initialization. Alternatively, it is possible
to set parameter <b>steadyStateStart</b> to <b>true</b>. In this case
the additional equation '<b>der</b>(T) = 0' is used during
initialization, i.e., the temperature T is computed in such a way that
the component starts in <b>steady state</b>. This is useful in cases,
where one would like to start simulation in a suitable operating
point without being forced to integrate for a long time to arrive
at this point.
</p>
<p>
Note, that parameter <b>steadyStateStart</b> is not available in
the parameter menu of the simulation window, because its value
is utilized during translation to generate quite different
equations depending on its setting. Therefore, the value of this
parameter can only be changed before translating the model.
</p>
<p>
This component may be used for complicated geometries where
the heat capacity C is determined my measurements. If the component
consists mainly of one type of material, the <b>mass m</b> of the
component may be measured or calculated and multiplied with the
<b>specific heat capacity cp</b> of the component material to
compute C:
</p>
<pre>
   C = cp*m.
   Typical values for cp at 20 degC in J/(kg.K):
      aluminium   896
      concrete    840
      copper      383
      iron        452
      silver      235
      steel       420 ... 500 (V2A)
      wood       2500
</pre>
</html>"));
        end HeatCapacitor;

        model ThermalConductor
        "Lumped thermal element transporting heat without storing it"
          extends Interfaces.Element1D;
          parameter Modelica.SIunits.ThermalConductance G
          "Constant thermal conductance of material";

        equation
          Q_flow = G*dT;
          annotation (
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                    100,100}}), graphics={
                Rectangle(
                  extent={{-90,70},{90,-70}},
                  lineColor={0,0,0},
                  pattern=LinePattern.None,
                  fillColor={192,192,192},
                  fillPattern=FillPattern.Backward),
                Line(
                  points={{-90,70},{-90,-70}},
                  color={0,0,0},
                  thickness=0.5),
                Line(
                  points={{90,70},{90,-70}},
                  color={0,0,0},
                  thickness=0.5),
                Text(
                  extent={{-150,115},{150,75}},
                  textString="%name",
                  lineColor={0,0,255}),
                Text(
                  extent={{-150,-75},{150,-105}},
                  lineColor={0,0,0},
                  textString="G=%G")}),
            Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
                    {100,100}}), graphics={
                Line(
                  points={{-80,0},{80,0}},
                  color={255,0,0},
                  thickness=0.5,
                  arrow={Arrow.None,Arrow.Filled}),
                Text(
                  extent={{-100,-20},{100,-40}},
                  lineColor={255,0,0},
                  textString="Q_flow"),
                Text(
                  extent={{-100,40},{100,20}},
                  lineColor={0,0,0},
                  textString="dT = port_a.T - port_b.T")}),
            Documentation(info="<HTML>
<p>
This is a model for transport of heat without storing it; see also:
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Components.ThermalResistor\">ThermalResistor</a>.
It may be used for complicated geometries where
the thermal conductance G (= inverse of thermal resistance)
is determined by measurements and is assumed to be constant
over the range of operations. If the component consists mainly of
one type of material and a regular geometry, it may be calculated,
e.g., with one of the following equations:
</p>
<ul>
<li><p>
    Conductance for a <b>box</b> geometry under the assumption
    that heat flows along the box length:</p>
    <pre>
    G = k*A/L
    k: Thermal conductivity (material constant)
    A: Area of box
    L: Length of box
    </pre>
    </li>
<li><p>
    Conductance for a <b>cylindrical</b> geometry under the assumption
    that heat flows from the inside to the outside radius
    of the cylinder:</p>
    <pre>
    G = 2*pi*k*L/log(r_out/r_in)
    pi   : Modelica.Constants.pi
    k    : Thermal conductivity (material constant)
    L    : Length of cylinder
    log  : Modelica.Math.log;
    r_out: Outer radius of cylinder
    r_in : Inner radius of cylinder
    </pre>
    </li>
</ul>
<pre>
    Typical values for k at 20 degC in W/(m.K):
      aluminium   220
      concrete      1
      copper      384
      iron         74
      silver      407
      steel        45 .. 15 (V2A)
      wood         0.1 ... 0.2
</pre>
</html>"));
        end ThermalConductor;
        annotation (Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100,-100},{100,100}}), graphics = {
          Rectangle(
            origin=  {12,40},
            fillColor=  {192,192,192},
            fillPattern=  FillPattern.Backward,
            extent=  {{-100,-100},{-70,18}}),
          Line(
            origin=  {12,40},
            points=  {{-44,16},{-44,-100}},
            color=  {0,127,255}),
          Line(
            origin=  {12,40},
            points=  {{-4,16},{-4,-100}},
            color=  {0,127,255}),
          Line(
            origin=  {12,40},
            points=  {{30,18},{30,-100}},
            color=  {0,127,255}),
          Line(
            origin=  {12,40},
            points=  {{66,18},{66,-100}},
            color=  {0,127,255}),
          Line(
            origin=  {12,40},
            points=  {{66,-100},{76,-80}},
            color=  {0,127,255}),
          Line(
            origin=  {12,40},
            points=  {{66,-100},{56,-80}},
            color=  {0,127,255}),
          Line(
            origin=  {12,40},
            points=  {{30,-100},{40,-80}},
            color=  {0,127,255}),
          Line(
            origin=  {12,40},
            points=  {{30,-100},{20,-80}},
            color=  {0,127,255}),
          Line(
            origin=  {12,40},
            points=  {{-4,-100},{6,-80}},
            color=  {0,127,255}),
          Line(
            origin=  {12,40},
            points=  {{-4,-100},{-14,-80}},
            color=  {0,127,255}),
          Line(
            origin=  {12,40},
            points=  {{-44,-100},{-34,-80}},
            color=  {0,127,255}),
          Line(
            origin=  {12,40},
            points=  {{-44,-100},{-54,-80}},
            color=  {0,127,255}),
          Line(
            origin=  {12,40},
            points=  {{-70,-60},{66,-60}},
            color=  {191,0,0}),
          Line(
            origin=  {12,40},
            points=  {{46,-70},{66,-60}},
            color=  {191,0,0}),
          Line(
            origin=  {12,40},
            points=  {{46,-50},{66,-60}},
            color=  {191,0,0}),
          Line(
            origin=  {12,40},
            points=  {{46,-30},{66,-20}},
            color=  {191,0,0}),
          Line(
            origin=  {12,40},
            points=  {{46,-10},{66,-20}},
            color=  {191,0,0}),
          Line(
            origin=  {12,40},
            points=  {{-70,-20},{66,-20}},
            color=  {191,0,0})}), Documentation(
              info="<html>

</html>"));
      end Components;

      package Sensors "Thermal sensors"
        extends Modelica.Icons.SensorsPackage;

        model TemperatureSensor "Absolute temperature sensor in Kelvin"

          Modelica.Blocks.Interfaces.RealOutput T(unit="K")
          "Absolute temperature as output signal"
            annotation (Placement(transformation(extent={{90,-10},{110,10}}, rotation=0)));
          Interfaces.HeatPort_a port annotation (Placement(transformation(extent={{
                    -110,-10},{-90,10}}, rotation=0)));
        equation
          T = port.T;
          port.Q_flow = 0;
          annotation (
            Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                    100,100}}), graphics={
                Ellipse(
                  extent={{-20,-98},{20,-60}},
                  lineColor={0,0,0},
                  lineThickness=0.5,
                  fillColor={191,0,0},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{-12,40},{12,-68}},
                  lineColor={191,0,0},
                  fillColor={191,0,0},
                  fillPattern=FillPattern.Solid),
                Line(points={{12,0},{90,0}}, color={0,0,255}),
                Line(points={{-94,0},{-14,0}}, color={191,0,0}),
                Polygon(
                  points={{-12,40},{-12,80},{-10,86},{-6,88},{0,90},{6,88},{10,86},{
                      12,80},{12,40},{-12,40}},
                  lineColor={0,0,0},
                  lineThickness=0.5),
                Line(
                  points={{-12,40},{-12,-64}},
                  color={0,0,0},
                  thickness=0.5),
                Line(
                  points={{12,40},{12,-64}},
                  color={0,0,0},
                  thickness=0.5),
                Line(points={{-40,-20},{-12,-20}}, color={0,0,0}),
                Line(points={{-40,20},{-12,20}}, color={0,0,0}),
                Line(points={{-40,60},{-12,60}}, color={0,0,0}),
                Text(
                  extent={{102,-28},{60,-78}},
                  lineColor={0,0,0},
                  textString="K")}),
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                    100,100}}), graphics={
                Ellipse(
                  extent={{-20,-98},{20,-60}},
                  lineColor={0,0,0},
                  lineThickness=0.5,
                  fillColor={191,0,0},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{-12,40},{12,-68}},
                  lineColor={191,0,0},
                  fillColor={191,0,0},
                  fillPattern=FillPattern.Solid),
                Line(points={{12,0},{90,0}}, color={0,0,255}),
                Line(points={{-90,0},{-12,0}}, color={191,0,0}),
                Polygon(
                  points={{-12,40},{-12,80},{-10,86},{-6,88},{0,90},{6,88},{10,86},
                      {12,80},{12,40},{-12,40}},
                  lineColor={0,0,0},
                  lineThickness=0.5),
                Line(
                  points={{-12,40},{-12,-64}},
                  color={0,0,0},
                  thickness=0.5),
                Line(
                  points={{12,40},{12,-64}},
                  color={0,0,0},
                  thickness=0.5),
                Line(points={{-40,-20},{-12,-20}}, color={0,0,0}),
                Line(points={{-40,20},{-12,20}}, color={0,0,0}),
                Line(points={{-40,60},{-12,60}}, color={0,0,0}),
                Text(
                  extent={{126,-20},{26,-120}},
                  lineColor={0,0,0},
                  textString="K"),
                Text(
                  extent={{-150,130},{150,90}},
                  textString="%name",
                  lineColor={0,0,255})}),
            Documentation(info="<HTML>
<p>
This is an ideal absolute temperature sensor which returns
the temperature of the connected port in Kelvin as an output
signal.  The sensor itself has no thermal interaction with
whatever it is connected to.  Furthermore, no
thermocouple-like lags are associated with this
sensor model.
</p>
</html>"));
        end TemperatureSensor;
        annotation (   Documentation(info="<html>

</html>"));
      end Sensors;

      package Interfaces "Connectors and partial models"
        extends Modelica.Icons.InterfacesPackage;

        partial connector HeatPort "Thermal port for 1-dim. heat transfer"
          Modelica.SIunits.Temperature T "Port temperature";
          flow Modelica.SIunits.HeatFlowRate Q_flow
          "Heat flow rate (positive if flowing from outside into the component)";
          annotation (Documentation(info="<html>

</html>"));
        end HeatPort;

        connector HeatPort_a
        "Thermal port for 1-dim. heat transfer (filled rectangular icon)"

          extends HeatPort;

          annotation(defaultComponentName = "port_a",
            Documentation(info="<HTML>
<p>This connector is used for 1-dimensional heat flow between components.
The variables in the connector are:</p>
<pre>
   T       Temperature in [Kelvin].
   Q_flow  Heat flow rate in [Watt].
</pre>
<p>According to the Modelica sign convention, a <b>positive</b> heat flow
rate <b>Q_flow</b> is considered to flow <b>into</b> a component. This
convention has to be used whenever this connector is used in a model
class.</p>
<p>Note, that the two connector classes <b>HeatPort_a</b> and
<b>HeatPort_b</b> are identical with the only exception of the different
<b>icon layout</b>.</p></html>"),         Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                    100,100}}), graphics={Rectangle(
                  extent={{-100,100},{100,-100}},
                  lineColor={191,0,0},
                  fillColor={191,0,0},
                  fillPattern=FillPattern.Solid)}),
            Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
                    {100,100}}), graphics={Rectangle(
                  extent={{-50,50},{50,-50}},
                  lineColor={191,0,0},
                  fillColor={191,0,0},
                  fillPattern=FillPattern.Solid), Text(
                  extent={{-120,120},{100,60}},
                  lineColor={191,0,0},
                  textString="%name")}));
        end HeatPort_a;

        connector HeatPort_b
        "Thermal port for 1-dim. heat transfer (unfilled rectangular icon)"

          extends HeatPort;

          annotation(defaultComponentName = "port_b",
            Documentation(info="<HTML>
<p>This connector is used for 1-dimensional heat flow between components.
The variables in the connector are:</p>
<pre>
   T       Temperature in [Kelvin].
   Q_flow  Heat flow rate in [Watt].
</pre>
<p>According to the Modelica sign convention, a <b>positive</b> heat flow
rate <b>Q_flow</b> is considered to flow <b>into</b> a component. This
convention has to be used whenever this connector is used in a model
class.</p>
<p>Note, that the two connector classes <b>HeatPort_a</b> and
<b>HeatPort_b</b> are identical with the only exception of the different
<b>icon layout</b>.</p></html>"),         Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
                    {100,100}}), graphics={Rectangle(
                  extent={{-50,50},{50,-50}},
                  lineColor={191,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid), Text(
                  extent={{-100,120},{120,60}},
                  lineColor={191,0,0},
                  textString="%name")}),
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                    100,100}}), graphics={Rectangle(
                  extent={{-100,100},{100,-100}},
                  lineColor={191,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid)}));
        end HeatPort_b;

        partial model Element1D
        "Partial heat transfer element with two HeatPort connectors that does not store energy"

          Modelica.SIunits.HeatFlowRate Q_flow
          "Heat flow rate from port_a -> port_b";
          Modelica.SIunits.TemperatureDifference dT "port_a.T - port_b.T";
      public
          HeatPort_a port_a annotation (Placement(transformation(extent={{-110,-10},
                    {-90,10}}, rotation=0)));
          HeatPort_b port_b annotation (Placement(transformation(extent={{90,-10},{
                    110,10}}, rotation=0)));
        equation
          dT = port_a.T - port_b.T;
          port_a.Q_flow = Q_flow;
          port_b.Q_flow = -Q_flow;
          annotation (Documentation(info="<HTML>
<p>
This partial model contains the basic connectors and variables to
allow heat transfer models to be created that <b>do not store energy</b>,
This model defines and includes equations for the temperature
drop across the element, <b>dT</b>, and the heat flow rate
through the element from port_a to port_b, <b>Q_flow</b>.
</p>
<p>
By extending this model, it is possible to write simple
constitutive equations for many types of heat transfer components.
</p>
</html>"));
        end Element1D;
        annotation (                               Documentation(info="<html>

</html>"));
      end Interfaces;
      annotation (
         Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100,-100},{100,100}}), graphics = {
          Polygon(
            origin=  {13.758,27.517},
            lineColor=  {128,128,128},
            fillColor=  {192,192,192},
            fillPattern=  FillPattern.Solid,
            points=  {{-54,-6},{-61,-7},{-75,-15},{-79,-24},{-80,-34},{-78,-42},{-73,-49},{-64,-51},{-57,-51},{-47,-50},{-41,-43},{-38,-35},{-40,-27},{-40,-20},{-42,-13},{-47,-7},{-54,-5},{-54,-6}}),
        Polygon(
            origin=  {13.758,27.517},
            fillColor=  {160,160,164},
            fillPattern=  FillPattern.Solid,
            points=  {{-75,-15},{-79,-25},{-80,-34},{-78,-42},{-72,-49},{-64,-51},{-57,-51},{-47,-50},{-57,-47},{-65,-45},{-71,-40},{-74,-33},{-76,-23},{-75,-15},{-75,-15}}),
          Polygon(
            origin=  {13.758,27.517},
            lineColor=  {160,160,164},
            fillColor=  {192,192,192},
            fillPattern=  FillPattern.Solid,
            points=  {{39,-6},{32,-7},{18,-15},{14,-24},{13,-34},{15,-42},{20,-49},{29,-51},{36,-51},{46,-50},{52,-43},{55,-35},{53,-27},{53,-20},{51,-13},{46,-7},{39,-5},{39,-6}}),
          Polygon(
            origin=  {13.758,27.517},
            fillColor=  {160,160,164},
            fillPattern=  FillPattern.Solid,
            points=  {{18,-15},{14,-25},{13,-34},{15,-42},{21,-49},{29,-51},{36,-51},{46,-50},{36,-47},{28,-45},{22,-40},{19,-33},{17,-23},{18,-15},{18,-15}}),
          Polygon(
            origin=  {13.758,27.517},
            lineColor=  {191,0,0},
            fillColor=  {191,0,0},
            fillPattern=  FillPattern.Solid,
            points=  {{-9,-23},{-9,-10},{18,-17},{-9,-23}}),
          Line(
            origin=  {13.758,27.517},
            points=  {{-41,-17},{-9,-17}},
            color=  {191,0,0},
            thickness=  0.5),
          Line(
            origin=  {13.758,27.517},
            points=  {{-17,-40},{15,-40}},
            color=  {191,0,0},
            thickness=  0.5),
          Polygon(
            origin=  {13.758,27.517},
            lineColor=  {191,0,0},
            fillColor=  {191,0,0},
            fillPattern=  FillPattern.Solid,
            points=  {{-17,-46},{-17,-34},{-40,-40},{-17,-46}})}),
                                Documentation(info="<HTML>
<p>
This package contains components to model <b>1-dimensional heat transfer</b>
with lumped elements. This allows especially to model heat transfer in
machines provided the parameters of the lumped elements, such as
the heat capacity of a part, can be determined by measurements
(due to the complex geometries and many materials used in machines,
calculating the lumped element parameters from some basic analytic
formulas is usually not possible).
</p>
<p>
Example models how to use this library are given in subpackage <b>Examples</b>.<br>
For a first simple example, see <b>Examples.TwoMasses</b> where two masses
with different initial temperatures are getting in contact to each
other and arriving after some time at a common temperature.<br>
<b>Examples.ControlledTemperature</b> shows how to hold a temperature
within desired limits by switching on and off an electric resistor.<br>
A more realistic example is provided in <b>Examples.Motor</b> where the
heating of an electrical motor is modelled, see the following screen shot
of this example:
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Thermal/HeatTransfer/driveWithHeatTransfer.png\" ALT=\"driveWithHeatTransfer\">
</p>

<p>
The <b>filled</b> and <b>non-filled red squares</b> at the left and
right side of a component represent <b>thermal ports</b> (connector HeatPort).
Drawing a line between such squares means that they are thermally connected.
The variables of a HeatPort connector are the temperature <b>T</b> at the port
and the heat flow rate <b>Q_flow</b> flowing into the component (if Q_flow is positive,
the heat flows into the element, otherwise it flows out of the element):
</p>
<pre>   Modelica.SIunits.Temperature  T  \"absolute temperature at port in Kelvin\";
   Modelica.SIunits.HeatFlowRate Q_flow  \"flow rate at the port in Watt\";
</pre>
<p>
Note, that all temperatures of this package, including initial conditions,
are given in Kelvin. For convenience, in subpackages <b>HeatTransfer.Celsius</b>,
 <b>HeatTransfer.Fahrenheit</b> and <b>HeatTransfer.Rankine</b> components are provided such that source and
sensor information is available in degree Celsius, degree Fahrenheit, or degree Rankine,
respectively. Additionally, in package <b>SIunits.Conversions</b> conversion
functions between the units Kelvin and Celsius, Fahrenheit, Rankine are
provided. These functions may be used in the following way:
</p>
<pre>  <b>import</b> SI=Modelica.SIunits;
  <b>import</b> Modelica.SIunits.Conversions.*;
     ...
  <b>parameter</b> SI.Temperature T = from_degC(25);  // convert 25 degree Celsius to Kelvin
</pre>

<p>
There are several other components available, such as AxialConduction (discretized PDE in
axial direction), which have been temporarily removed from this library. The reason is that
these components reference material properties, such as thermal conductivity, and currently
the Modelica design group is discussing a general scheme to describe material properties.
</p>
<p>
For technical details in the design of this library, see the following reference:<br>
<b>Michael Tiller (2001)</b>: <a href=\"http://www.amazon.de\">
Introduction to Physical Modeling with Modelica</a>.
Kluwer Academic Publishers Boston.
</p>
<p>
<b>Acknowledgements:</b><br>
Several helpful remarks from the following persons are acknowledged:
John Batteh, Ford Motors, Dearborn, U.S.A;
<a href=\"http://www.haumer.at/\">Anton Haumer</a>, Technical Consulting &amp; Electrical Engineering, Austria;
Ludwig Marvan, VA TECH ELIN EBG Elektronik GmbH, Wien, Austria;
Hans Olsson, Dassault Syst&egrave;mes AB, Sweden;
Hubertus Tummescheit, Lund Institute of Technology, Lund, Sweden.
</p>
<dl>
  <dt><b>Main Authors:</b></dt>
  <dd>
  <p>
  <a href=\"http://www.haumer.at/\">Anton Haumer</a><br>
  Technical Consulting &amp; Electrical Engineering<br>
  A-3423 St.Andrae-Woerdern, Austria<br>
  email: <a href=\"mailto:a.haumer@haumer.at\">a.haumer@haumer.at</a>
</p>
  </dd>
</dl>
<p><b>Copyright &copy; 2001-2013, Modelica Association, Michael Tiller and DLR.</b></p>

<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"https://www.modelica.org/licenses/ModelicaLicense2\"> https://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</html>",     revisions="<html>
<ul>
<li><i>July 15, 2002</i>
       by Michael Tiller, <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>
       and Nikolaus Sch&uuml;rmann:<br>
       Implemented.
</li>
<li><i>June 13, 2005</i>
       by <a href=\"http://www.haumer.at/\">Anton Haumer</a><br>
       Refined placing of connectors (cosmetic).<br>
       Refined all Examples; removed Examples.FrequencyInverter, introducing Examples.Motor<br>
       Introduced temperature dependent correction (1 + alpha*(T - T_ref)) in Fixed/PrescribedHeatFlow<br>
</li>
  <li> v1.1.1 2007/11/13 Anton Haumer<br>
       components moved to sub-packages</li>
  <li> v1.2.0 2009/08/26 Anton Haumer<br>
       added component ThermalCollector</li>

</ul>
</html>"));
    end HeatTransfer;
    annotation (
     Icon(coordinateSystem(extent={{-100.0,-100.0},{100.0,100.0}}), graphics={
      Line(
      origin={-47.5,11.6667},
      points={{-2.5,-91.6667},{17.5,-71.6667},{-22.5,-51.6667},{17.5,-31.6667},{-22.5,-11.667},{17.5,8.3333},{-2.5,28.3333},{-2.5,48.3333}},
        smooth=Smooth.Bezier),
      Polygon(
      origin={-50.0,68.333},
      pattern=LinePattern.None,
      fillPattern=FillPattern.Solid,
        points={{0.0,21.667},{-10.0,-8.333},{10.0,-8.333}}),
      Line(
      origin={2.5,11.6667},
      points={{-2.5,-91.6667},{17.5,-71.6667},{-22.5,-51.6667},{17.5,-31.6667},{-22.5,-11.667},{17.5,8.3333},{-2.5,28.3333},{-2.5,48.3333}},
        smooth=Smooth.Bezier),
      Polygon(
      origin={0.0,68.333},
      pattern=LinePattern.None,
      fillPattern=FillPattern.Solid,
        points={{0.0,21.667},{-10.0,-8.333},{10.0,-8.333}}),
      Line(
      origin={52.5,11.6667},
      points={{-2.5,-91.6667},{17.5,-71.6667},{-22.5,-51.6667},{17.5,-31.6667},{-22.5,-11.667},{17.5,8.3333},{-2.5,28.3333},{-2.5,48.3333}},
        smooth=Smooth.Bezier),
      Polygon(
      origin={50.0,68.333},
      pattern=LinePattern.None,
      fillPattern=FillPattern.Solid,
        points={{0.0,21.667},{-10.0,-8.333},{10.0,-8.333}})}),
      Documentation(info="<html>
<p>
This package contains libraries to model heat transfer
and fluid heat flow.
</p>
</html>"));
  end Thermal;

  package Constants
  "Library of mathematical constants and constants of nature (e.g., pi, eps, R, sigma)"
    import SI = Modelica.SIunits;
    import NonSI = Modelica.SIunits.Conversions.NonSIunits;
    extends Modelica.Icons.Package;

    final constant Real eps=ModelicaServices.Machine.eps
    "Biggest number such that 1.0 + eps = 1.0";

    final constant Real inf=ModelicaServices.Machine.inf
    "Biggest Real number such that inf and -inf are representable on the machine";

    final constant NonSI.Temperature_degC T_zero=-273.15
    "Absolute zero temperature";
    annotation (
      Documentation(info="<html>
<p>
This package provides often needed constants from mathematics, machine
dependent constants and constants from nature. The latter constants
(name, value, description) are from the following source:
</p>

<dl>
<dt>Peter J. Mohr and Barry N. Taylor (1999):</dt>
<dd><b>CODATA Recommended Values of the Fundamental Physical Constants: 1998</b>.
    Journal of Physical and Chemical Reference Data, Vol. 28, No. 6, 1999 and
    Reviews of Modern Physics, Vol. 72, No. 2, 2000. See also <a href=
\"http://physics.nist.gov/cuu/Constants/\">http://physics.nist.gov/cuu/Constants/</a></dd>
</dl>

<p>CODATA is the Committee on Data for Science and Technology.</p>

<dl>
<dt><b>Main Author:</b></dt>
<dd><a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a><br>
    Deutsches Zentrum f&uuml;r Luft und Raumfahrt e. V. (DLR)<br>
    Oberpfaffenhofen<br>
    Postfach 11 16<br>
    D-82230 We&szlig;ling<br>
    email: <a href=\"mailto:Martin.Otter@dlr.de\">Martin.Otter@dlr.de</a></dd>
</dl>

<p>
Copyright &copy; 1998-2013, Modelica Association and DLR.
</p>
<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"https://www.modelica.org/licenses/ModelicaLicense2\"> https://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</html>",   revisions="<html>
<ul>
<li><i>Nov 8, 2004</i>
       by <a href=\"http://www.robotic.dlr.de/Christian.Schweiger/\">Christian Schweiger</a>:<br>
       Constants updated according to 2002 CODATA values.</li>
<li><i>Dec 9, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Constants updated according to 1998 CODATA values. Using names, values
       and description text from this source. Included magnetic and
       electric constant.</li>
<li><i>Sep 18, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Constants eps, inf, small introduced.</li>
<li><i>Nov 15, 1997</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Realized.</li>
</ul>
</html>"),
      Icon(coordinateSystem(extent={{-100.0,-100.0},{100.0,100.0}}), graphics={
        Polygon(
          origin={-9.2597,25.6673},
          fillColor={102,102,102},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{48.017,11.336},{48.017,11.336},{10.766,11.336},{-25.684,10.95},{-34.944,-15.111},{-34.944,-15.111},{-32.298,-15.244},{-32.298,-15.244},{-22.112,0.168},{11.292,0.234},{48.267,-0.097},{48.267,-0.097}},
          smooth=Smooth.Bezier),
        Polygon(
          origin={-19.9923,-8.3993},
          fillColor={102,102,102},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{3.239,37.343},{3.305,37.343},{-0.399,2.683},{-16.936,-20.071},{-7.808,-28.604},{6.811,-22.519},{9.986,37.145},{9.986,37.145}},
          smooth=Smooth.Bezier),
        Polygon(
          origin={23.753,-11.5422},
          fillColor={102,102,102},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-10.873,41.478},{-10.873,41.478},{-14.048,-4.162},{-9.352,-24.8},{7.912,-24.469},{16.247,0.27},{16.247,0.27},{13.336,0.071},{13.336,0.071},{7.515,-9.983},{-3.134,-7.271},{-2.671,41.214},{-2.671,41.214}},
          smooth=Smooth.Bezier)}));
  end Constants;

  package Icons "Library of icons"
    extends Icons.Package;

    partial package ExamplesPackage
    "Icon for packages containing runnable examples"
      extends Modelica.Icons.Package;
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={
            Polygon(
              origin={8.0,14.0},
              lineColor={78,138,73},
              fillColor={78,138,73},
              pattern=LinePattern.None,
              fillPattern=FillPattern.Solid,
              points={{-58.0,46.0},{42.0,-14.0},{-58.0,-74.0},{-58.0,46.0}})}), Documentation(info="<html>
<p>This icon indicates a package that contains executable examples.</p>
</html>"));
    end ExamplesPackage;

    partial model Example "Icon for runnable examples"

      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
            Ellipse(lineColor = {75,138,73},
                    fillColor={255,255,255},
                    fillPattern = FillPattern.Solid,
                    extent = {{-100,-100},{100,100}}),
            Polygon(lineColor = {0,0,255},
                    fillColor = {75,138,73},
                    pattern = LinePattern.None,
                    fillPattern = FillPattern.Solid,
                    points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Documentation(info="<html>
<p>This icon indicates an example. The play button suggests that the example can be executed.</p>
</html>"));
    end Example;

    partial package Package "Icon for standard packages"

      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
            Rectangle(
              lineColor={200,200,200},
              fillColor={248,248,248},
              fillPattern=FillPattern.HorizontalCylinder,
              extent={{-100.0,-100.0},{100.0,100.0}},
              radius=25.0),
            Rectangle(
              lineColor={128,128,128},
              fillPattern=FillPattern.None,
              extent={{-100.0,-100.0},{100.0,100.0}},
              radius=25.0)}),   Documentation(info="<html>
<p>Standard package icon.</p>
</html>"));
    end Package;

    partial package BasesPackage "Icon for packages containing base classes"
      extends Modelica.Icons.Package;
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={
            Ellipse(
              extent={{-30.0,-30.0},{30.0,30.0}},
              lineColor={128,128,128},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid)}),
                                Documentation(info="<html>
<p>This icon shall be used for a package/library that contains base models and classes, respectively.</p>
</html>"));
    end BasesPackage;

    partial package VariantsPackage "Icon for package containing variants"
      extends Modelica.Icons.Package;
      annotation (Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},
                {100,100}}),       graphics={
            Ellipse(
              origin={10.0,10.0},
              fillColor={76,76,76},
              pattern=LinePattern.None,
              fillPattern=FillPattern.Solid,
              extent={{-80.0,-80.0},{-20.0,-20.0}}),
            Ellipse(
              origin={10.0,10.0},
              pattern=LinePattern.None,
              fillPattern=FillPattern.Solid,
              extent={{0.0,-80.0},{60.0,-20.0}}),
            Ellipse(
              origin={10.0,10.0},
              fillColor={128,128,128},
              pattern=LinePattern.None,
              fillPattern=FillPattern.Solid,
              extent={{0.0,0.0},{60.0,60.0}}),
            Ellipse(
              origin={10.0,10.0},
              lineColor={128,128,128},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid,
              extent={{-80.0,0.0},{-20.0,60.0}})}),
                                Documentation(info="<html>
<p>This icon shall be used for a package/library that contains several variants of one components.</p>
</html>"));
    end VariantsPackage;

    partial package InterfacesPackage "Icon for packages containing interfaces"
      extends Modelica.Icons.Package;
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={
            Polygon(origin={20.0,0.0},
              lineColor={64,64,64},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid,
              points={{-10.0,70.0},{10.0,70.0},{40.0,20.0},{80.0,20.0},{80.0,-20.0},{40.0,-20.0},{10.0,-70.0},{-10.0,-70.0}}),
            Polygon(fillColor={102,102,102},
              pattern=LinePattern.None,
              fillPattern=FillPattern.Solid,
              points={{-100.0,20.0},{-60.0,20.0},{-30.0,70.0},{-10.0,70.0},{-10.0,-70.0},{-30.0,-70.0},{-60.0,-20.0},{-100.0,-20.0}})}),
                                Documentation(info="<html>
<p>This icon indicates packages containing interfaces.</p>
</html>"));
    end InterfacesPackage;

    partial package SourcesPackage "Icon for packages containing sources"
      extends Modelica.Icons.Package;
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={
            Polygon(origin={23.3333,0.0},
              fillColor={128,128,128},
              pattern=LinePattern.None,
              fillPattern=FillPattern.Solid,
              points={{-23.333,30.0},{46.667,0.0},{-23.333,-30.0}}),
            Rectangle(
              fillColor=  {128,128,128},
              pattern=  LinePattern.None,
              fillPattern=  FillPattern.Solid,
              extent=  {{-70,-4.5},{0,4.5}})}),
                                Documentation(info="<html>
<p>This icon indicates a package which contains sources.</p>
</html>"));
    end SourcesPackage;

    partial package SensorsPackage "Icon for packages containing sensors"
      extends Modelica.Icons.Package;
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={
            Ellipse(origin={0.0,-30.0},
              fillColor={255,255,255},
              extent={{-90.0,-90.0},{90.0,90.0}},
              startAngle=20.0,
              endAngle=160.0),
            Ellipse(origin={0.0,-30.0},
              fillColor={128,128,128},
              pattern=LinePattern.None,
              fillPattern=FillPattern.Solid,
              extent={{-20.0,-20.0},{20.0,20.0}}),
            Line(origin={0.0,-30.0},
              points={{0.0,60.0},{0.0,90.0}}),
            Ellipse(origin={-0.0,-30.0},
              fillColor={64,64,64},
              pattern=LinePattern.None,
              fillPattern=FillPattern.Solid,
              extent={{-10.0,-10.0},{10.0,10.0}}),
            Polygon(
              origin={-0.0,-30.0},
              rotation=-35.0,
              fillColor={64,64,64},
              pattern=LinePattern.None,
              fillPattern=FillPattern.Solid,
              points={{-7.0,0.0},{-3.0,85.0},{0.0,90.0},{3.0,85.0},{7.0,0.0}})}),
                                Documentation(info="<html>
<p>This icon indicates a package containing sensors.</p>
</html>"));
    end SensorsPackage;

    partial package IconsPackage "Icon for packages containing icons"
      extends Modelica.Icons.Package;
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={Polygon(
              origin={-8.167,-17},
              fillColor={128,128,128},
              pattern=LinePattern.None,
              fillPattern=FillPattern.Solid,
              points={{-15.833,20.0},{-15.833,30.0},{14.167,40.0},{24.167,20.0},{
                  4.167,-30.0},{14.167,-30.0},{24.167,-30.0},{24.167,-40.0},{-5.833,
                  -50.0},{-15.833,-30.0},{4.167,20.0},{-5.833,20.0}},
              smooth=Smooth.Bezier,
              lineColor={0,0,0}), Ellipse(
              origin={-0.5,56.5},
              fillColor={128,128,128},
              pattern=LinePattern.None,
              fillPattern=FillPattern.Solid,
              extent={{-12.5,-12.5},{12.5,12.5}},
              lineColor={0,0,0})}));
    end IconsPackage;
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={Polygon(
              origin={-8.167,-17},
              fillColor={128,128,128},
              pattern=LinePattern.None,
              fillPattern=FillPattern.Solid,
              points={{-15.833,20.0},{-15.833,30.0},{14.167,40.0},{24.167,20.0},{
                  4.167,-30.0},{14.167,-30.0},{24.167,-30.0},{24.167,-40.0},{-5.833,
                  -50.0},{-15.833,-30.0},{4.167,20.0},{-5.833,20.0}},
              smooth=Smooth.Bezier,
              lineColor={0,0,0}), Ellipse(
              origin={-0.5,56.5},
              fillColor={128,128,128},
              pattern=LinePattern.None,
              fillPattern=FillPattern.Solid,
              extent={{-12.5,-12.5},{12.5,12.5}},
              lineColor={0,0,0})}), Documentation(info="<html>
<p>This package contains definitions for the graphical layout of components which may be used in different libraries. The icons can be utilized by inheriting them in the desired class using &quot;extends&quot; or by directly copying the &quot;icon&quot; layer. </p>

<h4>Main Authors:</h4>

<dl>
<dt><a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a></dt>
    <dd>Deutsches Zentrum fuer Luft und Raumfahrt e.V. (DLR)</dd>
    <dd>Oberpfaffenhofen</dd>
    <dd>Postfach 1116</dd>
    <dd>D-82230 Wessling</dd>
    <dd>email: <a href=\"mailto:Martin.Otter@dlr.de\">Martin.Otter@dlr.de</a></dd>
<dt>Christian Kral</dt>
    <dd><a href=\"http://www.ait.ac.at/\">Austrian Institute of Technology, AIT</a></dd>
    <dd>Mobility Department</dd><dd>Giefinggasse 2</dd>
    <dd>1210 Vienna, Austria</dd>
    <dd>email: <a href=\"mailto:dr.christian.kral@gmail.com\">dr.christian.kral@gmail.com</a></dd>
<dt>Johan Andreasson</dt>
    <dd><a href=\"http://www.modelon.se/\">Modelon AB</a></dd>
    <dd>Ideon Science Park</dd>
    <dd>22370 Lund, Sweden</dd>
    <dd>email: <a href=\"mailto:johan.andreasson@modelon.se\">johan.andreasson@modelon.se</a></dd>
</dl>

<p>Copyright &copy; 1998-2013, Modelica Association, DLR, AIT, and Modelon AB. </p>
<p><i>This Modelica package is <b>free</b> software; it can be redistributed and/or modified under the terms of the <b>Modelica license</b>, see the license conditions and the accompanying <b>disclaimer</b> in <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a>.</i> </p>
</html>"));
  end Icons;

  package SIunits
  "Library of type and unit definitions based on SI units according to ISO 31-1992"
    extends Modelica.Icons.Package;

    package Icons "Icons for SIunits"
      extends Modelica.Icons.IconsPackage;

      partial function Conversion "Base icon for conversion functions"

        annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={
              Rectangle(
                extent={{-100,100},{100,-100}},
                lineColor={191,0,0},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Line(points={{-90,0},{30,0}}, color={191,0,0}),
              Polygon(
                points={{90,0},{30,20},{30,-20},{90,0}},
                lineColor={191,0,0},
                fillColor={191,0,0},
                fillPattern=FillPattern.Solid),
              Text(
                extent={{-115,155},{115,105}},
                textString="%name",
                lineColor={0,0,255})}));
      end Conversion;
    end Icons;

    package Conversions
    "Conversion functions to/from non SI units and type definitions of non SI units"
      extends Modelica.Icons.Package;

      package NonSIunits "Type definitions of non SI units"
        extends Modelica.Icons.Package;

        type Temperature_degC = Real (final quantity="ThermodynamicTemperature",
              final unit="degC")
        "Absolute temperature in degree Celsius (for relative temperature use SIunits.TemperatureDifference)"
                                                                                                            annotation(absoluteValue=true);
        annotation (Documentation(info="<HTML>
<p>
This package provides predefined types, such as <b>Angle_deg</b> (angle in
degree), <b>AngularVelocity_rpm</b> (angular velocity in revolutions per
minute) or <b>Temperature_degF</b> (temperature in degree Fahrenheit),
which are in common use but are not part of the international standard on
units according to ISO 31-1992 \"General principles concerning quantities,
units and symbols\" and ISO 1000-1992 \"SI units and recommendations for
the use of their multiples and of certain other units\".</p>
<p>If possible, the types in this package should not be used. Use instead
types of package Modelica.SIunits. For more information on units, see also
the book of Francois Cardarelli <b>Scientific Unit Conversion - A
Practical Guide to Metrication</b> (Springer 1997).</p>
<p>Some units, such as <b>Temperature_degC/Temp_C</b> are both defined in
Modelica.SIunits and in Modelica.Conversions.NonSIunits. The reason is that these
definitions have been placed erroneously in Modelica.SIunits although they
are not SIunits. For backward compatibility, these type definitions are
still kept in Modelica.SIunits.</p>
</html>"),   Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Text(
          origin={15.0,51.8518},
          extent={{-105.0,-86.8518},{75.0,-16.8518}},
          lineColor={0,0,0},
          textString="[km/h]")}));
      end NonSIunits;

      function from_degC "Convert from degCelsius to Kelvin"
        extends Modelica.SIunits.Icons.Conversion;
        input NonSIunits.Temperature_degC Celsius "Celsius value";
        output Temperature Kelvin "Kelvin value";
      algorithm
        Kelvin := Celsius - Modelica.Constants.T_zero;
        annotation (Inline=true,Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={Text(
                extent={{-20,100},{-100,20}},
                lineColor={0,0,0},
                textString="degC"),  Text(
                extent={{100,-20},{20,-100}},
                lineColor={0,0,0},
                textString="K")}));
      end from_degC;
      annotation (                              Documentation(info="<HTML>
<p>This package provides conversion functions from the non SI Units
defined in package Modelica.SIunits.Conversions.NonSIunits to the
corresponding SI Units defined in package Modelica.SIunits and vice
versa. It is recommended to use these functions in the following
way (note, that all functions have one Real input and one Real output
argument):</p>
<pre>
  <b>import</b> SI = Modelica.SIunits;
  <b>import</b> Modelica.SIunits.Conversions.*;
     ...
  <b>parameter</b> SI.Temperature     T   = from_degC(25);   // convert 25 degree Celsius to Kelvin
  <b>parameter</b> SI.Angle           phi = from_deg(180);   // convert 180 degree to radian
  <b>parameter</b> SI.AngularVelocity w   = from_rpm(3600);  // convert 3600 revolutions per minutes
                                                      // to radian per seconds
</pre>

</html>"));
    end Conversions;

    type Time = Real (final quantity="Time", final unit="s");

    type ThermodynamicTemperature = Real (
        final quantity="ThermodynamicTemperature",
        final unit="K",
        min = 0.0,
        start = 288.15,
        nominal = 300,
        displayUnit="degC")
    "Absolute temperature (use type TemperatureDifference for relative temperatures)"
                                                                                                        annotation(absoluteValue=true);

    type Temperature = ThermodynamicTemperature;

    type TemperatureDifference = Real (
        final quantity="ThermodynamicTemperature",
        final unit="K") annotation(absoluteValue=false);

    type TemperatureSlope = Real (final quantity="TemperatureSlope",
        final unit="K/s");

    type HeatFlowRate = Real (final quantity="Power", final unit="W");

    type ThermalConductance = Real (final quantity="ThermalConductance", final unit=
               "W/K");

    type HeatCapacity = Real (final quantity="HeatCapacity", final unit="J/K");
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics={
          Line(
            points={{-66,78},{-66,-40}},
            color={64,64,64},
            smooth=Smooth.None),
          Ellipse(
            extent={{12,36},{68,-38}},
            lineColor={64,64,64},
            fillColor={175,175,175},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-74,78},{-66,-40}},
            lineColor={64,64,64},
            fillColor={175,175,175},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-66,-4},{-66,6},{-16,56},{-16,46},{-66,-4}},
            lineColor={64,64,64},
            smooth=Smooth.None,
            fillColor={175,175,175},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-46,16},{-40,22},{-2,-40},{-10,-40},{-46,16}},
            lineColor={64,64,64},
            smooth=Smooth.None,
            fillColor={175,175,175},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{22,26},{58,-28}},
            lineColor={64,64,64},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{68,2},{68,-46},{64,-60},{58,-68},{48,-72},{18,-72},{18,-64},
                {46,-64},{54,-60},{58,-54},{60,-46},{60,-26},{64,-20},{68,-6},{68,
                2}},
            lineColor={64,64,64},
            smooth=Smooth.Bezier,
            fillColor={175,175,175},
            fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<p>This package provides predefined types, such as <i>Mass</i>,
<i>Angle</i>, <i>Time</i>, based on the international standard
on units, e.g.,
</p>

<pre>   <b>type</b> Angle = Real(<b>final</b> quantity = \"Angle\",
                     <b>final</b> unit     = \"rad\",
                     displayUnit    = \"deg\");
</pre>

<p>
as well as conversion functions from non SI-units to SI-units
and vice versa in subpackage
<a href=\"modelica://Modelica.SIunits.Conversions\">Conversions</a>.
</p>

<p>
For an introduction how units are used in the Modelica standard library
with package SIunits, have a look at:
<a href=\"modelica://Modelica.SIunits.UsersGuide.HowToUseSIunits\">How to use SIunits</a>.
</p>

<p>
Copyright &copy; 1998-2013, Modelica Association and DLR.
</p>
<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"https://www.modelica.org/licenses/ModelicaLicense2\"> https://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</html>",   revisions="<html>
<ul>
<li><i>May 25, 2011</i> by Stefan Wischhusen:<br/>Added molar units for energy and enthalpy.</li>
<li><i>Jan. 27, 2010</i> by Christian Kral:<br/>Added complex units.</li>
<li><i>Dec. 14, 2005</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br/>Add User&#39;;s Guide and removed &quot;min&quot; values for Resistance and Conductance.</li>
<li><i>October 21, 2002</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a> and <a href=\"http://www.robotic.dlr.de/Christian.Schweiger/\">Christian Schweiger</a>:<br/>Added new package <b>Conversions</b>. Corrected typo <i>Wavelenght</i>.</li>
<li><i>June 6, 2000</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br/>Introduced the following new types<br/>type Temperature = ThermodynamicTemperature;<br/>types DerDensityByEnthalpy, DerDensityByPressure, DerDensityByTemperature, DerEnthalpyByPressure, DerEnergyByDensity, DerEnergyByPressure<br/>Attribute &quot;final&quot; removed from min and max values in order that these values can still be changed to narrow the allowed range of values.<br/>Quantity=&quot;Stress&quot; removed from type &quot;Stress&quot;, in order that a type &quot;Stress&quot; can be connected to a type &quot;Pressure&quot;.</li>
<li><i>Oct. 27, 1999</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br/>New types due to electrical library: Transconductance, InversePotential, Damping.</li>
<li><i>Sept. 18, 1999</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br/>Renamed from SIunit to SIunits. Subpackages expanded, i.e., the SIunits package, does no longer contain subpackages.</li>
<li><i>Aug 12, 1999</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br/>Type &quot;Pressure&quot; renamed to &quot;AbsolutePressure&quot; and introduced a new type &quot;Pressure&quot; which does not contain a minimum of zero in order to allow convenient handling of relative pressure. Redefined BulkModulus as an alias to AbsolutePressure instead of Stress, since needed in hydraulics.</li>
<li><i>June 29, 1999</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br/>Bug-fix: Double definition of &quot;Compressibility&quot; removed and appropriate &quot;extends Heat&quot; clause introduced in package SolidStatePhysics to incorporate ThermodynamicTemperature.</li>
<li><i>April 8, 1998</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a> and Astrid Jaschinski:<br/>Complete ISO 31 chapters realized.</li>
<li><i>Nov. 15, 1997</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a> and <a href=\"http://www.control.lth.se/~hubertus/\">Hubertus Tummescheit</a>:<br/>Some chapters realized.</li>
</ul>
</html>"));
  end SIunits;
annotation (
preferredView="info",
version="3.2.1",
versionBuild=2,
versionDate="2013-08-14",
dateModified = "2013-08-14 08:44:41Z",
revisionId="$Id:: package.mo 6947 2013-08-23 07:41:37Z #$",
uses(Complex(version="3.2.1"), ModelicaServices(version="3.2.1")),
conversion(
 noneFromVersion="3.2",
 noneFromVersion="3.1",
 noneFromVersion="3.0.1",
 noneFromVersion="3.0",
 from(version="2.1", script="modelica://Modelica/Resources/Scripts/Dymola/ConvertModelica_from_2.2.2_to_3.0.mos"),
 from(version="2.2", script="modelica://Modelica/Resources/Scripts/Dymola/ConvertModelica_from_2.2.2_to_3.0.mos"),
 from(version="2.2.1", script="modelica://Modelica/Resources/Scripts/Dymola/ConvertModelica_from_2.2.2_to_3.0.mos"),
 from(version="2.2.2", script="modelica://Modelica/Resources/Scripts/Dymola/ConvertModelica_from_2.2.2_to_3.0.mos")),
Icon(coordinateSystem(extent={{-100.0,-100.0},{100.0,100.0}}), graphics={
  Polygon(
    origin={-6.9888,20.048},
    fillColor={0,0,0},
    pattern=LinePattern.None,
    fillPattern=FillPattern.Solid,
    points={{-93.0112,10.3188},{-93.0112,10.3188},{-73.011,24.6},{-63.011,31.221},{-51.219,36.777},{-39.842,38.629},{-31.376,36.248},{-25.819,29.369},{-24.232,22.49},{-23.703,17.463},{-15.501,25.135},{-6.24,32.015},{3.02,36.777},{15.191,39.423},{27.097,37.306},{32.653,29.633},{35.035,20.108},{43.501,28.046},{54.085,35.19},{65.991,39.952},{77.897,39.688},{87.422,33.338},{91.126,21.696},{90.068,9.525},{86.099,-1.058},{79.749,-10.054},{71.283,-21.431},{62.816,-33.337},{60.964,-32.808},{70.489,-16.14},{77.368,-2.381},{81.072,10.054},{79.749,19.05},{72.605,24.342},{61.758,23.019},{49.587,14.817},{39.003,4.763},{29.214,-6.085},{21.012,-16.669},{13.339,-26.458},{5.401,-36.777},{-1.213,-46.037},{-6.24,-53.446},{-8.092,-52.387},{-0.684,-40.746},{5.401,-30.692},{12.81,-17.198},{19.424,-3.969},{23.658,7.938},{22.335,18.785},{16.514,23.283},{8.047,23.019},{-1.478,19.05},{-11.267,11.113},{-19.734,2.381},{-29.259,-8.202},{-38.519,-19.579},{-48.044,-31.221},{-56.511,-43.392},{-64.449,-55.298},{-72.386,-66.939},{-77.678,-74.612},{-79.53,-74.083},{-71.857,-61.383},{-62.861,-46.037},{-52.278,-28.046},{-44.869,-15.346},{-38.784,-2.117},{-35.344,8.731},{-36.403,19.844},{-42.488,23.813},{-52.013,22.49},{-60.744,16.933},{-68.947,10.054},{-76.884,2.646},{-93.0112,-12.1707},{-93.0112,-12.1707}},
    smooth=Smooth.Bezier),
  Ellipse(
    origin={40.8208,-37.7602},
    fillColor={161,0,4},
    pattern=LinePattern.None,
    fillPattern=FillPattern.Solid,
    extent={{-17.8562,-17.8563},{17.8563,17.8562}})}),
Documentation(info="<HTML>
<p>
Package <b>Modelica&reg;</b> is a <b>standardized</b> and <b>free</b> package
that is developed together with the Modelica&reg; language from the
Modelica Association, see
<a href=\"https://www.Modelica.org\">https://www.Modelica.org</a>.
It is also called <b>Modelica Standard Library</b>.
It provides model components in many domains that are based on
standardized interface definitions. Some typical examples are shown
in the next figure:
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/UsersGuide/ModelicaLibraries.png\">
</p>

<p>
For an introduction, have especially a look at:
</p>
<ul>
<li> <a href=\"modelica://Modelica.UsersGuide.Overview\">Overview</a>
  provides an overview of the Modelica Standard Library
  inside the <a href=\"modelica://Modelica.UsersGuide\">User's Guide</a>.</li>
<li><a href=\"modelica://Modelica.UsersGuide.ReleaseNotes\">Release Notes</a>
 summarizes the changes of new versions of this package.</li>
<li> <a href=\"modelica://Modelica.UsersGuide.Contact\">Contact</a>
  lists the contributors of the Modelica Standard Library.</li>
<li> The <b>Examples</b> packages in the various libraries, demonstrate
  how to use the components of the corresponding sublibrary.</li>
</ul>

<p>
This version of the Modelica Standard Library consists of
</p>
<ul>
<li><b>1360</b> models and blocks, and</li>
<li><b>1280</b> functions</li>
</ul>
<p>
that are directly usable (= number of public, non-partial classes). It is fully compliant
to <a href=\"https://www.modelica.org/documents/ModelicaSpec32Revision2.pdf\">Modelica Specification Version 3.2 Revision 2</a>
and it has been tested with Modelica tools from different vendors.
</p>

<p>
<b>Licensed by the Modelica Association under the Modelica License 2</b><br>
Copyright &copy; 1998-2013, ABB, AIT, T.&nbsp;B&ouml;drich, DLR, Dassault Syst&egrave;mes AB, Fraunhofer, A.Haumer, ITI, Modelon,
TU Hamburg-Harburg, Politecnico di Milano, XRG Simulation.
</p>

<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"https://www.modelica.org/licenses/ModelicaLicense2\"> https://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>

<p>
<b>Modelica&reg;</b> is a registered trademark of the Modelica Association.
</p>
</html>"));
end Modelica;

package Buildings "Library with models for building energy and control systems"
  extends Modelica.Icons.Package;

  package HeatTransfer "Package with heat transfer models"
    extends Modelica.Icons.Package;

    package Sources "Thermal sources"
    extends Modelica.Icons.SourcesPackage;

      model FixedTemperature "Fixed temperature boundary condition in Kelvin"

        parameter Modelica.SIunits.Temperature T "Fixed temperature at port";
        Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port annotation (Placement(transformation(extent={{90,
                  -10},{110,10}}, rotation=0)));
      equation
        port.T = T;
        annotation (
          Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                  100,100}}), graphics={
              Text(
                extent={{-150,150},{150,110}},
                textString="%name",
                lineColor={0,0,255}),
              Text(
                extent={{-150,-110},{150,-140}},
                lineColor={0,0,0},
                textString="T=%T"),
              Rectangle(
                extent={{-100,100},{100,-100}},
                lineColor={0,0,0},
                pattern=LinePattern.None,
                fillColor={159,159,223},
                fillPattern=FillPattern.Backward),
              Text(
                extent={{0,0},{-100,-100}},
                lineColor={0,0,0},
                textString="K"),
              Line(
                points={{-52,0},{56,0}},
                color={191,0,0},
                thickness=0.5),
              Polygon(
                points={{50,-20},{50,20},{90,0},{50,-20}},
                lineColor={191,0,0},
                fillColor={191,0,0},
                fillPattern=FillPattern.Solid)}),
          Documentation(info="<HTML>
<p>
This model defines a fixed temperature T at its port in Kelvin,
i.e., it defines a fixed temperature as a boundary condition.
</p>
</HTML>
"),       Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                  100,100}}), graphics={
              Rectangle(
                extent={{-100,100},{100,-101}},
                lineColor={0,0,0},
                pattern=LinePattern.None,
                fillColor={159,159,223},
                fillPattern=FillPattern.Backward),
              Line(
                points={{-52,0},{56,0}},
                color={191,0,0},
                thickness=0.5),
              Text(
                extent={{0,0},{-100,-100}},
                lineColor={0,0,0},
                textString="K"),
              Polygon(
                points={{52,-20},{52,20},{90,0},{52,-20}},
                lineColor={191,0,0},
                fillColor={191,0,0},
                fillPattern=FillPattern.Solid)}));
      end FixedTemperature;

      model PrescribedHeatFlow "Prescribed heat flow boundary condition"
        Modelica.Blocks.Interfaces.RealInput Q_flow
              annotation (Placement(transformation(
              origin={-100,0},
              extent={{20,-20},{-20,20}},
              rotation=180)));
        Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port annotation (Placement(transformation(extent={{90,
                  -10},{110,10}}, rotation=0)));
      equation
        port.Q_flow = -Q_flow;
        annotation (
          Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                  100,100}}), graphics={
              Line(
                points={{-60,-20},{40,-20}},
                color={191,0,0},
                thickness=0.5),
              Line(
                points={{-60,20},{40,20}},
                color={191,0,0},
                thickness=0.5),
              Line(
                points={{-80,0},{-60,-20}},
                color={191,0,0},
                thickness=0.5),
              Line(
                points={{-80,0},{-60,20}},
                color={191,0,0},
                thickness=0.5),
              Polygon(
                points={{40,0},{40,40},{70,20},{40,0}},
                lineColor={191,0,0},
                fillColor={191,0,0},
                fillPattern=FillPattern.Solid),
              Polygon(
                points={{40,-40},{40,0},{70,-20},{40,-40}},
                lineColor={191,0,0},
                fillColor={191,0,0},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{70,40},{90,-40}},
                lineColor={191,0,0},
                fillColor={191,0,0},
                fillPattern=FillPattern.Solid),
              Text(
                extent={{-150,100},{150,60}},
                textString="%name",
                lineColor={0,0,255})}),
          Documentation(info="<HTML>
<p>
This model allows a specified amount of heat flow rate to be \"injected\"
into a thermal system at a given port.  The amount of heat
is given by the input signal Q_flow into the model. The heat flows into the
component to which the component PrescribedHeatFlow is connected,
if the input signal is positive.
</p>
<p>
This model is identical to
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow\">
Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow</a>, except that
the parameters <code>alpha</code> and <code>T_ref</code> have
been deleted as these can cause division by zero in some fluid flow models.
</p>
</HTML>
",    revisions="<html>
<ul>
<li>
March 29 2011, by Michael Wetter:<br/>
First implementation based on <a href=\"modelica://Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow\">
Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow</a>.
</li>
</ul>
</html>"),       Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
                  {100,100}}), graphics={
              Line(
                points={{-60,-20},{68,-20}},
                color={191,0,0},
                thickness=0.5),
              Line(
                points={{-60,20},{68,20}},
                color={191,0,0},
                thickness=0.5),
              Line(
                points={{-80,0},{-60,-20}},
                color={191,0,0},
                thickness=0.5),
              Line(
                points={{-80,0},{-60,20}},
                color={191,0,0},
                thickness=0.5),
              Polygon(
                points={{60,0},{60,40},{90,20},{60,0}},
                lineColor={191,0,0},
                fillColor={191,0,0},
                fillPattern=FillPattern.Solid),
              Polygon(
                points={{60,-40},{60,0},{90,-20},{60,-40}},
                lineColor={191,0,0},
                fillColor={191,0,0},
                fillPattern=FillPattern.Solid)}));
      end PrescribedHeatFlow;
      annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                -100},{100,100}})),   Documentation(info="<html>
This package is identical to
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Sources\">
Modelica.Thermal.HeatTransfer.Sources</a>, except that
the parameters <code>alpha</code> and <code>T_ref</code> have
been deleted in the models
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow\">
Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow</a> and
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow\">
Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow</a>
 as these can cause division by zero in some fluid flow models.
</html>"));
    end Sources;
  annotation (preferredView="info", Documentation(info="<html>
This package contains models for heat transfer elements.
</html>"));
  end HeatTransfer;

  package Utilities "Package with utility functions such as for I/O"
    extends Modelica.Icons.Package;

    package IO "Package with I/O functions"
      extends Modelica.Icons.VariantsPackage;

      package BCVTB
      "Package with functions to communicate with the Building Controls Virtual Test Bed"
        extends Modelica.Icons.VariantsPackage;

        model BCVTB
        "Block that exchanges data with the Building Controls Virtual Test Bed"
          extends Modelica.Blocks.Interfaces.DiscreteBlock(final startTime=0,
          final samplePeriod = if activateInterface then timeStep else Modelica.Constants.inf);
          parameter Boolean activateInterface = true
          "Set to false to deactivate interface and use instead yFixed as output"
            annotation(Evaluate = true);
          parameter Modelica.SIunits.Time timeStep
          "Time step used for the synchronization"
            annotation(Dialog(enable = activateInterface));
          parameter String xmlFileName = "socket.cfg"
          "Name of the file that is generated by the BCVTB and that contains the socket information";
          parameter Integer nDblWri(min=0)
          "Number of double values to write to the BCVTB";
          parameter Integer nDblRea(min=0)
          "Number of double values to be read from the BCVTB";
          parameter Integer flaDblWri[nDblWri] = zeros(nDblWri)
          "Flag for double values (0: use current value, 1: use average over interval, 2: use integral over interval)";
          parameter Real uStart[nDblWri]
          "Initial input signal, used during first data transfer with BCVTB";
          parameter Real yRFixed[nDblRea] = zeros(nDblRea)
          "Fixed output, used if activateInterface=false"
            annotation(Evaluate = true,
                        Dialog(enable = not activateInterface));

          Modelica.Blocks.Interfaces.RealInput uR[nDblWri]
          "Real inputs to be sent to the BCVTB"
            annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
          Modelica.Blocks.Interfaces.RealOutput yR[nDblRea]
          "Real outputs received from the BCVTB"
            annotation (Placement(transformation(extent={{100,-10},{120,10}})));

         Integer flaRea "Flag received from BCVTB";
         Modelica.SIunits.Time simTimRea
          "Current simulation time received from the BCVTB";
         Integer retVal "Return value from the BSD socket data exchange";
      protected
          parameter Integer socketFD(fixed=false)
          "Socket file descripter, or a negative value if an error occured";
          parameter Real _uStart[nDblWri](fixed=false)
          "Initial input signal, used during first data transfer with BCVTB";
          constant Integer flaWri=0;
          Real uRInt[nDblWri] "Value of integral";
          Real uRIntPre[nDblWri]
          "Value of integral at previous sampling instance";
      public
          Real uRWri[nDblWri] "Value to be sent to the interface";
        initial algorithm
          socketFD :=if activateInterface then
              Buildings.Utilities.IO.BCVTB.BaseClasses.establishClientSocket(xmlFileName=xmlFileName) else
              0;
            // check for valid socketFD
             assert(socketFD >= 0, "Socket file descripter for BCVTB must be positive.\n" +
                                 "   A negative value indicates that no connection\n" +
                                 "   could be established. Check file 'utilSocket.log'.\n" +
                                 "   Received: socketFD = " + String(socketFD));
           flaRea   := 0;
           uRInt    := zeros(nDblWri);
           uRIntPre := zeros(nDblWri);
           for i in 1:nDblWri loop
             assert(flaDblWri[i]>=0 and flaDblWri[i]<=2,
                "Parameter flaDblWri out of range for " + String(i) + "-th component.");
             if (flaDblWri[i] == 0) then
                _uStart[i] := uStart[i];               // Current value.
             elseif (flaDblWri[i] == 1) then
                _uStart[i] := uStart[i];                // Average over interval
             else
                _uStart[i] := uStart[i]*samplePeriod;  // Integral over the sampling interval
                                                       // This is multiplied with samplePeriod because if
                                                       // u is power, then uRWri needs to be energy.

             end if;
           end for;
           // Exchange initial values
            if activateInterface then
              (flaRea, simTimRea, yR, retVal) :=
                Buildings.Utilities.IO.BCVTB.BaseClasses.exchangeReals(
                socketFD=socketFD,
                flaWri=flaWri,
                simTimWri=time,
                dblValWri=_uStart,
                nDblWri=size(uRWri, 1),
                nDblRea=size(yR, 1));
            else
              flaRea := 0;
              simTimRea := time;
              yR := yRFixed;
              retVal := 0;
              end if;

        equation
           for i in 1:nDblWri loop
              der(uRInt[i]) = if (flaDblWri[i] > 0) then uR[i] else 0;
           end for;
        algorithm
          when {sampleTrigger} then
            assert(flaRea == 0, "BCVTB interface attempts to exchange data after Ptolemy reached its final time.\n" +
                                "   Aborting simulation. Check final time in Modelica and in Ptolemy.\n" +
                                "   Received: flaRea = " + String(flaRea));
             // Compute value that will be sent to the BCVTB interface
             for i in 1:nDblWri loop
               if (flaDblWri[i] == 0) then
                 uRWri[i] :=pre(uR[i]);  // Send the current value.
                                         // Without the pre(), Dymola 7.2 crashes during translation of Examples.MoistAir
               else
                 uRWri[i] :=uRInt[i] - uRIntPre[i]; // Integral over the sampling interval
                 if (flaDblWri[i] == 1) then
                    uRWri[i] := uRWri[i]/samplePeriod;   // Average value over the sampling interval
                 end if;
               end if;
              end for;

            // Exchange data
            if activateInterface then
              (flaRea, simTimRea, yR, retVal) :=
                Buildings.Utilities.IO.BCVTB.BaseClasses.exchangeReals(
                socketFD=socketFD,
                flaWri=flaWri,
                simTimWri=time,
                dblValWri=uRWri,
                nDblWri=size(uRWri, 1),
                nDblRea=size(yR, 1));
            else
              flaRea := 0;
              simTimRea := time;
              yR := yRFixed;
              retVal := 0;
              end if;
            // Check for valid return flags
            assert(flaRea >= 0, "BCVTB sent a negative flag to Modelica during data transfer.\n" +
                                "   Aborting simulation. Check file 'utilSocket.log'.\n" +
                                "   Received: flaRea = " + String(flaRea));
            assert(retVal >= 0, "Obtained negative return value during data transfer with BCVTB.\n" +
                                "   Aborting simulation. Check file 'utilSocket.log'.\n" +
                                "   Received: retVal = " + String(retVal));

            // Store current value of integral
          uRIntPre:=uRInt;
          end when;
           // Close socket connnection
           when terminal() then
             if activateInterface then
                Buildings.Utilities.IO.BCVTB.BaseClasses.closeClientSocket(
                                                                  socketFD);
             end if;
           end when;

          annotation (defaultComponentName="cliBCVTB",
           Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                    100}}),            graphics), Icon(coordinateSystem(
                  preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
                Rectangle(
                  visible=not activateInterface,
                  extent={{-100,-100},{100,100}},
                  lineColor={0,0,127},
                  fillColor={255,0,0},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  visible=activateInterface,
                  extent={{-100,-100},{100,100}},
                  lineColor={0,0,127},
                  fillColor={223,223,159},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{0,28},{80,-100}},
                  lineColor={0,0,0},
                  fillColor={95,95,95},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{10,14},{26,4}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{32,14},{48,4}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{54,14},{70,4}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{54,-2},{70,-12}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{32,-2},{48,-12}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{10,-2},{26,-12}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{54,-18},{70,-28}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{32,-18},{48,-28}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{10,-18},{26,-28}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{54,-34},{70,-44}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{32,-34},{48,-44}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{10,-34},{26,-44}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{54,-50},{70,-60}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{32,-50},{48,-60}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{10,-50},{26,-60}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{54,-66},{70,-76}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{32,-66},{48,-76}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{10,-66},{26,-76}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{54,-82},{70,-92}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{32,-82},{48,-92}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{10,-82},{26,-92}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Polygon(
                  points={{38,46},{-16,28},{92,28},{38,46}},
                  lineColor={0,0,0},
                  smooth=Smooth.None,
                  fillColor={0,0,0},
                  fillPattern=FillPattern.Solid),
                Text(
                  extent={{-82,108},{30,40}},
                  lineColor={0,0,0},
                  fillColor={95,95,95},
                  fillPattern=FillPattern.Solid,
                  textString="tS=%samplePeriod%")}),
            Documentation(info="<html>
Block that exchanges data with the 
<a href=\"http://simulationresearch.lbl.gov/bcvtb\">Building Controls Virtual Test Bed</a> (BCVTB).
<p>
At the start of the simulation, this block establishes a socket connection
using the Berkeley Software Distribution socket (BSD socket).
At each sampling interval, data are exchanged between Modelica
and the BCVTB.
When Dymola terminates, a signal is sent to the BCVTB
so that it can terminate gracefully.
</p>
<p>
For each element in the input vector <code>uR[nDblWri]</code>, 
the value of the flag <code>flaDblWri[nDblWri]</code> determines whether
the current value, the average over the sampling interval or the integral
over the sampling interval is sent to the BCVTB. The following three options are allowed:
<table summary=\"summary\" border=\"1\">
<tr>
<td>
flaDblWri[i]
</td>
<td>
Value sent to the BCVTB
</td>
</tr>
<tr>
<td>
0
</td>
<td>
Current value of uR[i]
</td>
</tr>
<tr>
<td>
1
</td>
<td>
Average value of uR[i] over the sampling interval
</td>
</tr>
<tr>
<td>
2
</td>
<td>
Integral of uR[i] over the sampling interval
</td>
</tr>
</table>
<br/>
<p>
For the first call to the BCVTB interface, the value of the parameter <code>uStart[nDblWri]</code>
will be used instead of <code>uR[nDblWri]</code>. This avoids an algebraic loop when determining
the initial conditions. If <code>uR[nDblWri]</code> were to be used, then computing the initial conditions
may require an iterative solution in which the function <code>exchangeWithSocket</code> may be called
multiple times.
Unfortunately, it does not seem possible to use a parameter that would give a user the option to either
select <code>uR[i]</code> or <code>uStart[i]</code> in the first data exchange. The reason is that the symbolic solver does not evaluate
the test that picks <code>uR[i]</code> or <code>uStart[i]</code>, and hence there would be an algebraic loop.
</p>
<p>
If the parameter <code>activateInterface</code> is set to false, then no data is exchanged with the BCVTB.
The output of this block is then equal to the value of the parameter <code>yRFixed[nDblRea]</code>.
This option can be helpful during debugging. Since during model translation, the functions are 
still linked to the C library, the header files and libraries need to be present in the current working 
directory even if <code>activateInterface=false</code>.
</p>
</html>",         revisions="<html>
<ul>
<li>
July 19, 2012, by Michael Wetter:<br/>
Added a call to <code>Buildings.Utilities.IO.BCVTB.BaseClasses.exchangeReals</code>
in the <code>initial algorithm</code> section.
This is needed to propagate the initial condition to the server.
It also leads to one more data exchange, which is correct and avoids the
warning message in Ptolemy that says that the simulation reached its stop time
one time step prior to the final time.
</li>
<li>
January 19, 2010, by Michael Wetter:<br/>
Introduced parameter to set initial value to be sent to the BCVTB.
In the prior implementation, if a variable was in an algebraic loop, then zero was
sent for this variable.
</li>
<li>
May 14, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
        end BCVTB;

        block To_degC "Converts Kelvin to Celsius"
          extends Modelica.Blocks.Icons.Block;

          Modelica.Blocks.Interfaces.RealInput Kelvin(final quantity="ThermodynamicTemperature",
                                                      final unit = "K", displayUnit = "degC", min=0)
          "Temperature in Kelvin"
            annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
                iconTransformation(extent={{-140,-20},{-100,20}})));
          Modelica.Blocks.Interfaces.RealOutput Celsius(final quantity="ThermodynamicTemperature",
                                                        final unit = "degC", displayUnit = "degC", min=-273.15)
          "Temperature in Celsius"
            annotation (Placement(transformation(extent={{100,-10},{120,10}}),
                iconTransformation(extent={{100,-10},{120,10}})));
        equation
          Kelvin = Modelica.SIunits.Conversions.from_degC(Celsius);
        annotation (
        defaultComponentName="toDegC",
        Documentation(info="<html>
<p>
Converts the input from degree Celsius to Kelvin.
Note that inside Modelica, it is strongly recommended to use
Kelvin. This block is provided for convenience since the BCVTB
interface may couple Modelica to programs that use Celsius 
as the unit for temperature.
</p>
</html>",
        revisions="<html>
<ul>
<li>
April 14, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),         Icon(graphics={               Text(
                  extent={{-26,96},{-106,16}},
                  lineColor={0,0,0},
                  textString="K"),
                Polygon(
                  points={{84,-4},{24,16},{24,-24},{84,-4}},
                  lineColor={191,0,0},
                  fillColor={191,0,0},
                  fillPattern=FillPattern.Solid),
                                   Text(
                  extent={{94,-24},{14,-104}},
                  lineColor={0,0,0},
                  textString="degC"),
                Line(points={{-96,-4},{24,-4}},
                                              color={191,0,0})}),
            Diagram(graphics));
        end To_degC;

        package Examples
        "Collection of models that illustrate model use and test models"
          extends Modelica.Icons.ExamplesPackage;

          model TwoRooms
          "Thermal model of two rooms that will be linked to the BCVTB which models the controls"
            extends Modelica.Icons.Example;
            parameter Modelica.SIunits.Time tau = 2*3600 "Room time constant";
            parameter Modelica.SIunits.HeatFlowRate Q_flow_nom = 100
            "Nominal heat flow";
            parameter Modelica.SIunits.ThermalConductance UA = Q_flow_nom / 20
            "Thermal conductance of room";
            parameter Modelica.SIunits.Temperature TStart = 283.15
            "Start temperature";
            Modelica.Thermal.HeatTransfer.Components.HeatCapacitor C1(C=tau*UA, T(start=
                    TStart, fixed=true)) "Heat capacity of room"
              annotation (Placement(transformation(extent={{70,70},{90,90}})));
            Modelica.Thermal.HeatTransfer.Components.ThermalConductor UA1(G=UA)
            "Heat transmission of room"
              annotation (Placement(transformation(extent={{40,60},{60,80}})));
            Buildings.HeatTransfer.Sources.FixedTemperature TOut1(T=278.15)
            "Outside air temperature"
              annotation (Placement(transformation(extent={{0,60},{20,80}})));
            Buildings.HeatTransfer.Sources.PrescribedHeatFlow Q_flow_1
            "Heat input into the room"
              annotation (Placement(transformation(extent={{42,20},{62,40}})));
            Modelica.Blocks.Math.Gain GaiQ_flow_nom1(k=Q_flow_nom)
            "Gain for nominal heat load"
              annotation (Placement(transformation(extent={{0,20},{20,40}})));
            Modelica.Thermal.HeatTransfer.Components.ThermalConductor UA2(G=UA)
            "Heat transmission of room"
              annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
            Modelica.Thermal.HeatTransfer.Components.HeatCapacitor C2(C=2*tau*UA, T(start=
                    TStart, fixed=true)) "Heat capacity of room"
              annotation (Placement(transformation(extent={{70,-28},{90,-8}})));
            Buildings.HeatTransfer.Sources.FixedTemperature TOut2(T=278.15)
            "Outside air temperature"
              annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
            Buildings.HeatTransfer.Sources.PrescribedHeatFlow Q_flow_2
            "Heat input into the room"
              annotation (Placement(transformation(extent={{44,-80},{64,-60}})));
            Modelica.Blocks.Math.Gain GaiQ_flow_nom2(k=Q_flow_nom)
            "Gain for nominal heat load"
              annotation (Placement(transformation(extent={{2,-80},{22,-60}})));
            Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TRoo1
            "Room temperature"
              annotation (Placement(transformation(extent={{92,60},{112,80}})));
            Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TRoo2
            "Room temperature"
              annotation (Placement(transformation(extent={{90,-40},{110,-20}})));
            Buildings.Utilities.IO.BCVTB.BCVTB bcvtb(
              xmlFileName="socket.cfg",
              uStart={TStart - 273.15,TStart - 273.15},
              timeStep=60,
              final nDblWri=2,
              final nDblRea=2)
              annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
            Modelica.Blocks.Routing.Multiplex2 multiplex2_1
              annotation (Placement(transformation(extent={{200,-10},{220,10}})));
            Modelica.Blocks.Routing.DeMultiplex2 deMultiplex2_1
              annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
            Buildings.Utilities.IO.BCVTB.To_degC to_degC1
              annotation (Placement(transformation(extent={{140,60},{160,80}})));
            Buildings.Utilities.IO.BCVTB.To_degC to_degC2
              annotation (Placement(transformation(extent={{140,-40},{160,-20}})));
          equation
            connect(TOut1.port, UA1.port_a) annotation (Line(
                points={{20,70},{40,70}},
                color={191,0,0},
                smooth=Smooth.None));
            connect(UA1.port_b, C1.port) annotation (Line(
                points={{60,70},{80,70}},
                color={191,0,0},
                smooth=Smooth.None));
            connect(TOut2.port, UA2.port_a) annotation (Line(
                points={{20,-30},{40,-30}},
                color={191,0,0},
                smooth=Smooth.None));
            connect(UA2.port_b, C2.port) annotation (Line(
                points={{60,-30},{79,-30},{79,-28},{80,-28}},
                color={191,0,0},
                smooth=Smooth.None));
            connect(Q_flow_1.port, C1.port) annotation (Line(
                points={{62,30},{80,30},{80,70}},
                color={191,0,0},
                smooth=Smooth.None));
            connect(Q_flow_2.port, C2.port) annotation (Line(
                points={{64,-70},{80,-70},{80,-28}},
                color={191,0,0},
                smooth=Smooth.None));
            connect(C1.port, TRoo1.port) annotation (Line(
                points={{80,70},{92,70}},
                color={191,0,0},
                smooth=Smooth.None));
            connect(C2.port, TRoo2.port) annotation (Line(
                points={{80,-28},{80,-30},{90,-30}},
                color={191,0,0},
                smooth=Smooth.None));
            connect(GaiQ_flow_nom1.y, Q_flow_1.Q_flow) annotation (Line(
                points={{21,30},{42,30}},
                color={0,0,127},
                smooth=Smooth.None));
            connect(GaiQ_flow_nom2.y, Q_flow_2.Q_flow) annotation (Line(
                points={{23,-70},{44,-70}},
                color={0,0,127},
                smooth=Smooth.None));
            connect(bcvtb.yR, deMultiplex2_1.u) annotation (Line(
                points={{-59,6.10623e-16},{-54.75,6.10623e-16},{-54.75,1.27676e-15},{
                    -50.5,1.27676e-15},{-50.5,6.66134e-16},{-42,6.66134e-16}},
                color={0,0,127},
                smooth=Smooth.None));
            connect(deMultiplex2_1.y1[1], GaiQ_flow_nom1.u) annotation (Line(
                points={{-19,6},{-11.5,6},{-11.5,30},{-2,30}},
                color={0,0,127},
                smooth=Smooth.None));
            connect(deMultiplex2_1.y2[1], GaiQ_flow_nom2.u) annotation (Line(
                points={{-19,-6},{-10,-6},{-10,-70},{-6.66134e-16,-70}},
                color={0,0,127},
                smooth=Smooth.None));
            connect(multiplex2_1.y, bcvtb.uR) annotation (Line(
                points={{221,6.10623e-16},{230,6.10623e-16},{230,-92},{-90,-92},{-90,
                    6.66134e-16},{-82,6.66134e-16}},
                color={0,0,127},
                smooth=Smooth.None));
            connect(TRoo1.T, to_degC1.Kelvin) annotation (Line(
                points={{112,70},{138,70}},
                color={0,0,127},
                smooth=Smooth.None));
            connect(TRoo2.T, to_degC2.Kelvin) annotation (Line(
                points={{110,-30},{138,-30}},
                color={0,0,127},
                smooth=Smooth.None));
            connect(to_degC2.Celsius, multiplex2_1.u2[1]) annotation (Line(
                points={{161,-30},{180,-30},{180,-6},{198,-6}},
                color={0,0,127},
                smooth=Smooth.None));
            connect(to_degC1.Celsius, multiplex2_1.u1[1]) annotation (Line(
                points={{161,70},{180,70},{180,6},{198,6}},
                color={0,0,127},
                smooth=Smooth.None));
            annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                      -100},{240,100}})),
              experiment(StopTime=21600),
              Documentation(info="<html>
This example illustrates the use of Modelica with the Building Controls Virtual Test Bed.<br/>
<p>
Given a control signal for two heat flow rates, Modelica simulates the thermal response 
of two first order systems. The two systems may represent a first order approximation of a room.
The control signal for the heat flow rate is computed in the Building Controls Virtual Test Bed
using a discrete time implementation of a proportional controller.
Every 60 seconds, measured temperatures and control signals for the heat flow rates are
exchanged between Dymola and the Building Controls Virtual Test Bed.
</p>
<p>
This model is implemented in <code>bcvtb\\examples\\dymola-room</code>.
</html>",           revisions="<html>
<ul>
<li>
May 15, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
          end TwoRooms;
        annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains examples for the use of models that can be found in
<a href=\"modelica://Buildings.Utilities.IO.BCVTB\">
Buildings.Utilities.IO.BCVTB</a>.
</p>
</html>"));
        end Examples;

        package BaseClasses
        "Package with base classes for Buildings.Utilities.IO.BCVTB"
          extends Modelica.Icons.BasesPackage;

          function establishClientSocket
          "Establishes the client socket connection"

            input String xmlFileName = "socket.cfg"
            "Name of xml file that contains the socket information";
            output Integer socketFD
            "Socket file descripter, or a negative value if an error occured";
            external "C"
               socketFD =
                        establishModelicaClient(xmlFileName)
                 annotation(Library="bcvtb_modelica",
                            Include="#include \"bcvtb.h\"");
          annotation(Documentation(info="<html>
Function that establishes a socket connection to the BCVTB.
<p>
For the xml file name, on Windows use two backslashes to separate directories, i.e., use
<pre>
  xmlFileName=\"C:\\\\examples\\\\dymola-room\\\\socket.cfg\"
</pre>
</html>", revisions="<html>
<ul>
<li>
May 5, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
          end establishClientSocket;

          function exchangeReals
          "Exchanges values of type Real with the socket"

            input Integer socketFD(min=1) "Socket file descripter";
            input Integer flaWri
            "Communication flag to write to the socket stream";
            input Modelica.SIunits.Time simTimWri
            "Current simulation time in seconds to write";
            input Real[nDblWri] dblValWri "Double values to write";
            input Integer nDblWri "Number of double values to write";
            input Integer nDblRea "Number of double values to read";
            output Integer flaRea
            "Communication flag read from the socket stream";
            output Modelica.SIunits.Time simTimRea
            "Current simulation time in seconds read from socket";
            output Real[nDblRea] dblValRea "Double values read from socket";
            output Integer retVal
            "The exit value, which is negative if an error occured";
            external "C"
               retVal =
                      exchangeModelicaClient(socketFD,
                 flaWri, flaRea,
                 simTimWri,
                 dblValWri, nDblWri,
                 simTimRea,
                 dblValRea, nDblRea)
              annotation(Library="bcvtb_modelica",
                  Include="#include \"bcvtb.h\"");
          annotation(Documentation(info="<html>
Function to exchange data of type <code>Real</code> with the socket.
This function must only be called once in each 
communication interval.
</html>", revisions="<html>
<ul>
<li>
May 5, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
          end exchangeReals;

          function closeClientSocket
          "Closes the socket for the inter process communication"

            input Integer socketFD
            "Socket file descripter, or a negative value if an error occured";
            output Integer retVal
            "Return value of the function that closes the socket connection";
            external "C"
               retVal =
                      closeModelicaClient(socketFD)
                 annotation(Library="bcvtb_modelica",
                            Include="#include \"bcvtb.h\"");
          annotation(Documentation(info="<html>
Function that closes the inter-process communication.
</html>", revisions="<html>
<ul>
<li>
May 5, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
          end closeClientSocket;
        annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains base classes that are used to construct the models in
<a href=\"modelica://Buildings.Utilities.IO.BCVTB\">Buildings.Utilities.IO.BCVTB</a>.
</p>
</html>"));
        end BaseClasses;
      end BCVTB;
    annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains components models for input and output.
Its package
<a href=\"modelica://Buildings.Utilities.IO.BCVTB\">
Buildings.Utilities.IO.BCVTB</a>
can be used for co-simulation with the
<a href=\"http://simulationresearch.lbl.gov/bcvtb\">
Building Controls Virtual Test Bed</a>.
</p>
</html>"));
    end IO;
  annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains utility models such as for thermal comfort calculation, input/output, co-simulation, psychrometric calculations and various functions that are used throughout the library.
</p>
</html>"));
  end Utilities;
annotation (
preferredView="info",
version="1.6",
versionBuild=0,
versionDate="2013-10-24",
dateModified = "2013-10-24",
uses(Modelica(version="3.2.1")),
uses(Modelica_StateGraph2(version="2.0.2")),
conversion(
 from(version="1.5",
      script="modelica://Buildings/Resources/Scripts/Dymola/ConvertBuildings_from_1.5_to_1.6.mos"),
 from(version="1.4",
      script="modelica://Buildings/Resources/Scripts/Dymola/ConvertBuildings_from_1.4_to_1.5.mos"),
 noneFromVersion="1.3",
 noneFromVersion="1.2",
 from(version="1.1",
      script="modelica://Buildings/Resources/Scripts/Dymola/ConvertBuildings_from_1.1_to_1.2.mos"),
 from(version="1.0",
      script="modelica://Buildings/Resources/Scripts/Dymola/ConvertBuildings_from_1.0_to_1.1.mos"),
 from(version="0.12",
      script="modelica://Buildings/Resources/Scripts/Dymola/ConvertBuildings_from_0.12_to_1.0.mos")),
revisionId="$Id$",
preferredView="info",
Documentation(info="<html>
<p>
The <code>Buildings</code> library is a free library
for modeling building energy and control systems. 
Many models are based on models from the package
<code>Modelica.Fluid</code> and use
the same ports to ensure compatibility with the Modelica Standard
Library.
</p>
<p>
The figure below shows a section of the schematic view of the model 
<a href=\"modelica://Buildings.Examples.HydronicHeating\">
Buildings.Examples.HydronicHeating</a>.
In the lower part of the figure, there is a dynamic model of a boiler, a pump and a stratified energy storage tank. Based on the temperatures of the storage tank, a finite state machine switches the boiler and its pump on and off. 
The heat distribution is done using a hydronic heating system with a three way valve and a pump with variable revolutions. The upper right hand corner shows a room model that is connected to a radiator whose flow is controlled by a thermostatic valve.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/UsersGuide/HydronicHeating.png\" border=\"1\"/>
</p>
<p>
The web page for this library is
<a href=\"http://simulationresearch.lbl.gov/modelica\">http://simulationresearch.lbl.gov/modelica</a>,
and the development page is
<a href=\"https://github.com/lbl-srg/modelica-buildings\">https://github.com/lbl-srg/modelica-buildings</a>.
Contributions to further advance the library are welcomed.
Contributions may not only be in the form of model development, but also
through model use, model testing,
requirements definition or providing feedback regarding the model applicability
to solve specific problems.
</p>
</html>"));
end Buildings;
model Buildings_Utilities_IO_BCVTB_Examples_TwoRooms
 extends Buildings.Utilities.IO.BCVTB.Examples.TwoRooms;
  annotation(experiment(StopTime=21600),uses(Buildings(version="1.6")));
end Buildings_Utilities_IO_BCVTB_Examples_TwoRooms;
