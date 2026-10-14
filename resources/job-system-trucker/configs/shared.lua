DeliveryCompanyName = "RS Haul"

Vehicle_Deletion_Interval = 10*60*1000
Vehicle_Restock_Duration = 12*1000

Available_Trucks = {
    [482] = {name = "Burrito", customID = 185, capacity = 30, rent = 125},
    [498] = {name = "Boxville", customID = 196, capacity = 65, rent = 255},
    [440] = {name = "Rumpo", customID = 180, capacity = 55},
    [499] = {name = "Benson", customID = 405, capacity = 50},
    [414] = {name = "Mule", customID = 375, capacity = 75},
    [456] = {name = "Yankee", customID = 195, capacity = 100}
}

Available_PostOffice = {
    name = "Bureau de poste",
    skin = 27,
    position = {2447.861328125, -2121.23828125, 13.546875}, rotation = 0, dimension = 0, interior = 0,
    vehicleSpawn = {
        {2460.8369140625, -2117.470703125, 13.552991867065, rotation = 0},
        {2484.28515625, -2117.470703125, 13.552991867065, rotation = 0},
        {2508.576171875, -2117.470703125, 13.552991867065, rotation = 0}
    }
}

Available_WareHouses = {
     {
         routePoint = {
             radius = 20,
             color = {219, 48, 0, 150},
         },
         loadPoint = {
             color = {0, 255, 0, 150},
             {789.9462890625, -610.900390625, 15.343282699585}
         }
     },

     {
         routePoint = {
             radius = 20,
             color = {219, 48, 0, 150},
         },
         loadPoint = {
             color = {0, 255, 0, 150},
             {830.0751953125, -610.900390625, 15.343282699585}
         }
     },
    
    {
        routePoint = {
            radius = 20,
            color = {219, 48, 0, 150},
        },
        loadPoint = {
            color = {0, 255, 0, 150},
            {2173.283203125, -2264.40234375, 12.349409103394}
        }
    },
}