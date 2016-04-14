//
//  Flags.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 01/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

struct Flags {

    /// The presence of this property indicates which units were used for the data in this request.
    ///  - **us** The default.
    ///  - **uk** Depricated.  Replaced by uk2.
    ///  - **uk2** As si except that wind speed is in mph and long distances in miles.
    ///  - **si** Results are in SI units.
    ///  - **ca** As si except that wind speed is in kph not m/s.
    let units: String?
    
    /// The ID of each data source utilized in servicing this request.
    let sources: [String]?
    /// The ID of each ISD station utilized in servicing this request.
    let isdStations: [String]?
    /// The ID of each METAR station utilized in servicing this request.
    let madisStations: [String]?
    /// The ID of each radar station utilized in servicing this request.
    let darkskyStations: [String]?
    /// The ID of each DataPoint station utilized in servicing this request.
    let datapointStations: [String]?


}
