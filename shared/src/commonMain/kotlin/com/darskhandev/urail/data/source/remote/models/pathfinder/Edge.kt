package com.darskhandev.urail.data.source.remote.models.pathfinder

import com.darskhandev.urail.data.source.remote.models.station.StationModel
import kotlinx.serialization.Serializable

@Serializable
data class Edge(
    val source: String,
    val destination: String,
    val distance: Double
)
@Serializable
data class EdgeItem(
    val source: StationModel,
    val destination: StationModel,
    val distance: Double
)

val bogorLine=listOf("BOO","CLT","BJD","CTA","DP","DPB","POC","UI","UP","LNA","TNT","PSM","PSMB","DRN","CW","TEB","MRI","CKI","GDD","JUA","SW","MGB","JAY","JAKK")
val bogorLineExtended=listOf("NMO","CBN","CTA")
val rkline=listOf("RK","CTR","MJ","CKY","TGS","TEJ","DAR","CJT","PRP","CC","CSK","SRP","RU","SDM","JMU","PDJ","KBY","PLM","THB")
val tgline=listOf("TNG","TTI","BPR","PI","KDS","RW","BOI","TKO","PSG","GGL","DU")
val tpkline=listOf("JAKK","KPB","AC","TPK")
val ckrline1=listOf("CKR","MTM","CIT","TB","BKST","BKS","KRI","CUK","KLDB","BUA","KLD","JNG")
val lingkarckrline1=listOf("JNG","POK","KMT","GST","PSE","KMO","RJW","KPB")
val lingkarckrline2=listOf("JNG","MTR","MRI","SUD","SUDB","KAT","THB","DU","AK","KPB")
//bogorLine red
//ckrline1 or lingkarckr blue
//tgline coklat
//rkLine green
//tpkLine pink

//create extention to get Edge color hex depending on the line who pass the edge

fun EdgeItem.getLineColor():String{
    val path = listOf(source.stationId,destination.stationId)
    if (bogorLine.containsAll(path)||bogorLine.reversed().containsAll(path)) return "#FF0000"
    if (ckrline1.containsAll(path)||ckrline1.reversed().containsAll(path)) return "#1CBBEE"
    if (tgline.containsAll(path)||tgline.reversed().containsAll(path)) return "#d2691e"
    if (rkline.containsAll(path)||rkline.reversed().containsAll(path)) return "#008000"
    if (tpkline.containsAll(path)||tpkline.reversed().containsAll(path)) return "#DD0067"
    if (lingkarckrline1.containsAll(path)||lingkarckrline1.reversed().containsAll(path)) return "#1CBBEE"
    if (lingkarckrline2.containsAll(path)||lingkarckrline2.reversed().containsAll(path)) return "#1CBBEE"
    return "#1CBBEE"
}
