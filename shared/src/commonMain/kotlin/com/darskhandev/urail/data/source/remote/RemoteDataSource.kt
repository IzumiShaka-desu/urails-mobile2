package com.darskhandev.urail.data.source.remote

import com.darskhandev.urail.data.source.remote.models.MetaResponse
import com.darskhandev.urail.data.source.remote.models.pathfinder.Graph
import com.darskhandev.urail.data.source.remote.models.pathfinder.PathFindingResult
import com.darskhandev.urail.data.source.remote.models.schedule.DetailScheduleRaw
import com.darskhandev.urail.data.source.remote.models.schedule.RouteScheduleRaw
import com.darskhandev.urail.data.source.remote.models.schedule.ScheduleRaw
import com.darskhandev.urail.data.source.remote.models.station.StationModel
import io.ktor.client.HttpClient
import io.ktor.client.call.body
import io.ktor.client.request.get
import io.ktor.client.request.header
import io.ktor.client.request.post
import io.ktor.client.request.setBody
import io.ktor.client.statement.HttpResponse
import io.ktor.http.ContentType
import io.ktor.http.HttpHeaders
import io.ktor.http.HttpMethod
import io.ktor.http.HttpStatusCode
import io.ktor.http.contentType

class RemoteDataSource(
    private val client: HttpClient,
    private val baseUrl: String
) : ApiServices {
    override suspend fun getKrlStations(): Result<MetaResponse<List<StationModel>>> {
        return tryRequest {
            client.get("$baseUrl/stations")
        }
    }

    override suspend fun getKrlSchedule(
        stationId: String,
        timeFrom: String,
        timeTo: String
    ): Result<MetaResponse<List<ScheduleRaw>>> {
        return tryRequest {
            client.get("$baseUrl/schedule?stationId=$stationId&timeFrom=$timeFrom&timeTo=$timeTo")
        }
    }

    override suspend fun getKrlRoute(
        originStationId: String,
        destinationStationId: String,
        departureTime: String
    ): Result<MetaResponse<PathFindingResult>> {
        return tryRequest {
            client.get("$baseUrl/routes?origin=$originStationId&destination=$destinationStationId&timeFrom=$departureTime")
        }
    }

    override suspend fun getGraph(): Result<MetaResponse<Graph>> {
        return tryRequest {
            client.get("$baseUrl/routes/graph")
        }
    }

    override suspend fun getDetailSchedule(kaId: String): Result<MetaResponse<DetailScheduleRaw>> {
        return tryRequest {
            client.get("$baseUrl/schedule/$kaId")
        }
    }

    override suspend fun getRouteSchedule(
        routes: List<String>,
        timeFrom: String
    ): Result<MetaResponse<List<RouteScheduleRaw>>> {
        return tryRequest {
            client.post("$baseUrl/routes/schedules?timeFrom=$timeFrom") {
                method = HttpMethod.Post
                contentType(ContentType.Application.Json)
                header(HttpHeaders.Accept, ContentType.Application.Json.toString())
                setBody(routes)
           }
            //            https://raw.githubusercontent.com/IzumiShaka-desu/final-arc_the-bridge-of-two-ages/main/projects/urail_scrapper/ckrtoctr.json?token=GHSAT0AAAAAABSV3YNSGQBLIWRA5TNROQ4IZE5FR4Q
//            get dummy
  //          client.get("https://raw.githubusercontent.com/IzumiShaka-desu/gif_host/main/routeschedule1.json")

        }
    }

    private suspend inline fun <reified T : Any> tryRequest(request: () -> HttpResponse): Result<T> {
        return try {
            val response = request()
            when (response.status) {
                HttpStatusCode.Accepted, HttpStatusCode.OK -> {
                    Result.success(response.body())
                }

                HttpStatusCode.BadRequest -> {
                    Result.failure(Exception("Connection Error : Bad Request"))
                }

                HttpStatusCode.NotFound -> {
                    Result.failure(Exception("Connection Error: NotFound"))
                }

                else -> {
                    Result.failure(Exception("Connection Error: code ${response.status}"))
                }
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
}
