require 'yaml'
require './Tournament'

Shoes.app(title: "Viewer - TinyTron", width: 800, height: 600, resizable: false) do
  @tourneyPath = "NONE"
  @roomID = "NONE"
  @counter = 0
  
  @currentIndex = 0
  
  @tournamentCache
  
  #Information Panel
  flow(width: 1.0, height: 0.1) do
    background white
    flow(width: 0.5) do
      @titleID = title
    end
    flow(width: 0.4)
    flow(width: 0.1) do
      @timer = subtitle "0:00"
    end
  end
  
  #Player Rankings
  flow(width: 0.4, height: 0.9, margin_top: 20, margin_left: 20, margin_bottom: 20) do
    border black, strokewidth: 2.5
    @playerRankings = stack(scroll: true, width: 1.0, height: 1.0)
  end
  
  #Upcoming Matches
  flow(width: 0.6, height: 0.9) do
    #Current Match
    flow(height: 0.4, margin_top: 20, margin_left: 20, margin_right: 20, margin_bottom: 20) do 
      border black, strokewidth: 2.5
      stack() do 
      @m1 = tagline ""
      @m2 = tagline ""
      @m3 = tagline ""
      @m4 = tagline ""
      end
    end
    #Next Three Matches
    flow(height: 0.6, margin_left: 20, margin_right: 20, margin_bottom: 20) do
      border black, strokewidth: 2.5
      @matches = stack(width: 1.0, height: 1.0)
    end
  end
  
  every(1) do   
      
      if(@tourneyPath == "NONE")
             alert("Please select the tournament file.")
             @tourneyPath = ask_open_file
             p @tourneyPath
            end
      
      if(@roomID == "NONE")
            while(!(@roomID == "A" || @roomID == "B"))
              @roomID = ask("Please enter the Room ID (A or B)").upcase
            end
            @titleID.replace(" #{@roomID}")
      end
      
      if(@counter == 0)
        tourneyFile = File.open(@tourneyPath,"r+")
        tourney = YAML.load(tourneyFile)
        updateInformation(tourney)
        tourneyFile.close
        @counter = 5
      else
        @counter = @counter - 1
      end
      
    @timer.text = "0:0#{@counter}"
  end
   
  def updateInformation(tourney)
    
         if(@roomID == "A")
            @currentIndex = tourney.indexA
            match_list = tourney.matchesA
         else
            @currentIndex = tourney.indexB
           match_list = tourney.matchesB
         end
         
         player_list = tourney.players
         
         #Update Player Rankings
         
         @playerRankings.clear
         
         for i in 0...player_list.size do
           @playerRankings.append{
           flow(height: 20, width: 1.0) do
             flow(width: 0.8){para "#{player_list[i].name}"}
             flow(width: 0.2){para "#{player_list[i].score}"} 
           end
         }
         end
         
         #update Matches
         currentMatch = match_list[@currentIndex]
         @m1.replace(currentMatch[0])
         @m2.replace(currentMatch[1])
         @m3.replace(currentMatch[2])
         @m4.replace(currentMatch[3])
         
         @matches.clear
         
=begin
         if(match_list[@currentIndex - 1] != nil)
           currentMatch = match_list[@currentIndex -1]
           @matches.append{
              flow(height: 20, width: 1.0){para currentMatch[0]}
              flow(height: 20, width: 1.0){para currentMatch[1]}
              flow(height: 20, width: 1.0){para currentMatch[2]}
              flow(height: 20, width: 1.0){para currentMatch[3]}
              flow(height: 20, width: 1.0){para "----------------------------"}
           }
         end
         
         if(match_list[@currentIndex - 2] != nil)
           currentMatch = match_list[@currentIndex -2]
           @matches.append{
             flow(height: 20, width: 1.0){para currentMatch[0]}
             flow(height: 20, width: 1.0){para currentMatch[1]}
             flow(height: 20, width: 1.0){para currentMatch[2]}
             flow(height: 20, width: 1.0){para currentMatch[3]}
             flow(height: 20, width: 1.0){para "----------------------------"}
           }
         end
         
         if(match_list[@currentIndex - 3] != nil)
           currentMatch = match_list[@currentIndex -3]
           @matches.append{
             flow(height: 20, width: 1.0){para currentMatch[0]}
             flow(height: 20, width: 1.0){para currentMatch[1]}
             flow(height: 20, width: 1.0){para currentMatch[2]}
             flow(height: 20, width: 1.0){para currentMatch[3]}
           }
         end
         
=end
         
        upComing = match_list.slice(@currentIndex+1...@currentIndex+4)
        p upComing

        for j in 0...upComing.size do
          currentMatch = upComing[j]
          @matches.append{
            flow(height: 20, width: 1.0){para currentMatch[0]}
            flow(height: 20, width: 1.0){para currentMatch[1]}
            flow(height: 20, width: 1.0){para currentMatch[2]}
            flow(height: 20, width: 1.0){para currentMatch[3]}
            flow(height: 20, width: 1.0){para "----------------------------"}
          }
        end
         
       end
   
end