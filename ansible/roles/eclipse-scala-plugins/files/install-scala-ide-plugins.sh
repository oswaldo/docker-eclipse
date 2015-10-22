#!/bin/sh
cd /opt/eclipse && \
./eclipse \
    -clean -purgeHistory \
    -application org.eclipse.equinox.p2.director \
    -noSplash \
    -repository \
http://download.eclipse.org/releases/juno,\
http://download.scala-ide.org/sdk/lithium/e44/scala211/stable/site\
    -installIUs \
org.scala-ide.sdt.feature.feature.group,\
org.scala-ide.scala211.feature.feature.group,\
org.scala-ide.scala211.source.feature.feature.group,\
org.scala-ide.sbt.feature.feature.group,\
org.scala-ide.play2.feature.feature.group,\
org.scala.tools.eclipse.search.feature.feature.group,\
org.scalaide.worksheet.feature.feature.group,\
org.scala-ide.sdt.scalatest.feature.feature.group;
