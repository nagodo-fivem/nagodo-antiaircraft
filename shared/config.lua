Config = { 

    Framework = "standalone", -- Name of the framework you are using (qb-core, esx, standalone). If you are using standalone, you can only use vehicleModels
    
    Zones = {
        {
            coords = vector3(1689.37, 2592.81, 78.34), -- Center of the zone
            radius = 200.0, -- Radius of the zone
            
            needOneOfBoth = false, -- If true, player needs to has one of the jobs in the table below and should be in one of the vehicles in the table below
            allowedJobs = {"police"}, -- Name of the job. If you are using standalone, you can only use vehicleModels
            allowedVehicleModels = {"polmav"}, -- Name of the vehicle model

            missileAccuracy = 99, -- Accuracy of the missile (0-100). The higher the number, the more accurate the missile will be
        },
    },

    BlipData = {
        Radius = {
            Color = 1,
            Alpha = 80,
        },
        Marker = {
            Sprite = 16,
            Scale = 1.0,
            Color = 0,
            label = "No access",
        },
    }

}
