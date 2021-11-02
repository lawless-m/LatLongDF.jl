module LatLongDF

using DataFrames

export distanceKm

const pid180 = pi / 180

struct LatLongS
	lat
	long
	LatLongS(lat, long) = new(lat * pid180, long * pid180)
end

# see https://spatialthoughts.com/2013/07/06/calculate-distance-spreadsheet/

function distanceKm(ll1::LatLongS, ll2::LatLongS)
	df = 2 * 6371 * asin(sqrt((sin((ll2.lat-ll1.lat)/2))^2+cos(ll2.lat)*cos(ll1.lat)*sin(((ll2.long-ll1.long)/2))^2))
end

function distanceKm(startdf::DataFrame, enddf::DataFrame)
	startp = eachrow(startdf[!, [:Latitude, :Longitude]])[1]
	endp = eachrow(enddf[!, [:Latitude, :Longitude]])[1]
	distanceKm(LatLongS(startp[1], startp[2]), LatLongS(endp[1], endp[2]))
end

function distanceKm(lat, long, enddf::DataFrame)
	endp = eachrow(enddf[!, [:Latitude, :Longitude]])[1]
	distanceKm(LatLongS(lat, long), LatLongS(endp[1], endp[2]))
end

function distanceKm(lat1, long1, lat2, long2)
	distanceKm(LatLongS(lat1, long1), LatLongS(lat2, long2))
end

###
end