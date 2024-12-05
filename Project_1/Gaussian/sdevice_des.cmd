File {
   Grid       = "@tdr@" 
   Parameters = "@parameter@"
   Plot       = "@tdrdat@"
   Current    = "@plot@" 
   Output     = "@log@"	
}	

Electrode {
   { Name="electrode1"   Voltage=0}
   { Name="electrode2" Voltage= 0}
   
}

Physics {
   AreaFactor = 1e3
   Temperature = 300
   Mobility ( 
      PhuMob
      HighFieldSaturation
      Enormal
   )
      EffectiveIntrinsicDensity( Slotboom )
      Recombination (
      	      SRH(DopingDependence Tempdep)
      	      Auger
      	      eAvalanche (Eparallel)
      	      hAvalanche (Eparallel)
             )
}

Insert = "PlotSection_des.cmd"
Math {

   Method = blocked
   Number_of_Threads = 2
   Transient= BE
     
   Extrapolate
   Notdamped= 50
   Iterations= 20
   ExitOnFailure
   RelErrControl
   Avalderivatives
   ErRef(Electron)=1.e10
   ErRef(Hole)=1.e10
   CNormprint
   BreakCriteria{ Current(Contact="electrode1" AbsVal=1)
   }
}

Solve {
   Poisson
   Coupled { Poisson Electron Hole }


   NewCurrentPrefix="IcVc_"

																
Quasistationary (
      InitialStep=1e-9 Increment=1.5
      MinStep=@<1e-8/1e10>@ MaxStep=1e-5
      Goal { Name=electrode2 Value=1 }
   ){ Coupled { Poisson Electron Hole }
      }
   Save(FilePrefix="vg5")
   
 
}



