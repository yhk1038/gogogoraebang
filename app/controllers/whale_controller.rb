class WhaleController < ApplicationController

  def login
    unless current_user.nil?
    redirect_to :action => "firstpage"
    end
  end
  
  def firstpage
    
      @test = current_user.lists
      @test_array = Array.new
      @test.each do |jack|
        @test_array << jack.song_id
      end
    unless @test_array[0].nil?
      redirect_to :action => "main"
    else
    end
    
  end
  
  
  def main
    if current_user.nil?
      redirect_to :action => "login"
    end
    
      #저장된목록 불러오기 초기값
      @all_song_list_title_array = Array.new
      @all_song_list_singer_array = Array.new
      @all_song_list_img_array = Array.new
      @all_song_feeling_content = Array.new
      #User의 저장된 노래 불러오기
      @all_song_list = User.find_by(id: current_user.id).lists.all
          @all_song_list.each do |hold|
              @find_song =  Song.find_by(id: hold.song_id)
              @all_song_list_title_array << @find_song.title
              @all_song_list_singer_array << @find_song.singer
              @all_song_list_img_array << @find_song.album_img
              @all_song_feeling_content << hold.feeling_content
              
          end
            
            @feeling_icon_count = Array.new
            for a in (0..4)
            @feeling_icon_count[a] = Array.new
            end
            
            @pre_feeling = List.all
            

            
          @pre_feeling.each do |prnum|
            for aa in 0..4
              if (prnum.user_id == current_user.id) & (prnum.feeling_id == aa+1)
                @feeling_icon_count[aa] << prnum.song_id
              end
            end
          end
              
                
                
            
            
            

            
      @all_song_size = @all_song_list.size

  end
  
  def saving_song
   @test = params[:pass_song_id]
   @test2 = params[:emotion_check]
   
       #밑에2줄 지워도됨
   # @test1 = params[:search_modal_main_song] #노래 id

    @feeling_address = params[:emotion_check] # 기분 주소 
    @feeling_address_id = Feeling.find_by(id: params[:emotion_check])
    
    @current_user_list_array = Array.new
    #넘어온 곡의 아이디. hidden_value로 곡의 id가 넘어옴
    @find_song = Song.find_by(id: params[:pass_song_id])
    @find_song_array = Array.new
    #넘어온 곡의 id를 배열의 형태로 바꿔줌
    @find_song_array << @find_song.id
    #@current_user_list에 접속자의 lists 넣음.
    #현재 유저가 있으면 @current_user_list에 current_user.lists.all을 저장하겠다.
    unless current_user.nil?    
    @current_user_list = current_user.lists.all
    end
    #@current_user_list_array에 현재유저의 곡 id를 배열로 넣음
    @current_user_list.each do |hold|    
        @current_user_list_array << hold.song_id
    end
    
    #중복된 것은 저장안하기
    if (@find_song_array-@current_user_list_array).empty?
        else
        save_list = List.new
        save_list.user_id = current_user.id
        save_list.song_id = @find_song.id
        save_list.feeling_content = @feeling_address
        save_list.feeling_id = @feeling_address_id
        save_list.save        
    end    
    
     redirect_to "/whale/search?search_sing=" + URI.encode(params[:search_sing_name])
   
   
  
  end
  
  
  
  
  
  def search
      #없을때는 그냥 페이지
    if params[:search_sing].nil?
        return
    else
    end
    #비슷한 검색어로 노래 찾기
    @showing_array_title1 = Array.new
    @saved_song = Song.all                  
    @saved_song.each do |h|
        if (h.title.similar(params[:search_sing]) >= 80 )
            @showing_array_title1 << h.title
        end
    end
    #현재 유저의 id 저장
    unless current_user.nil?
    session[:user_id] = current_user.id
    end
    @search_sing_size = params[:search_sing].size
    # 검색어구가 있는 노래 제목 찾기
    @check_all_song = Array.new
    @saved_song.each do |pp|
        for a in (0..(pp.title.size-@search_sing_size))
            if  pp.title.slice(0+a..(@search_sing_size-1+a)) == params[:search_sing]
                @check_all_song << pp.title
            else             
            end
        end
    end
    # 특정단어와 시밀러 리스트 합치기
    @union_song_list = Array.new
    @union_title = @check_all_song | @showing_array_title1
    # 합친 것을 Song의 정보로 담아서 그대로 출력하기
    @union_title.each do |mm|
        @union_song_list << Song.find_by(title: mm)
    end
    @showing_array_title = Array.new
    @showing_array_singer = Array.new
    @showing_array_id = Array.new
    @showing_array_album = Array.new
    @union_song_list.each do |jj|
        @showing_array_title << jj.title
        @showing_array_singer << jj.singer
        @showing_array_id << jj.id
        @showing_array_album << jj.album_img
        
    end
    
    @test_last_array = Array.new
    @test = Presearch.all
    @test.each do |pp|
      @test_last_array << pp.song_id
    end
    
  end
  
  

  
  
  def search_modal
    
    p = Presearch.new
    p.song_id = params[:song_id]
    p.user_id = current_user.id
    p.save
    
    
    @sleep = Presearch.all
    @array_save = Array.new
    @sleep.each do |kk|
      @array_save << kk.song_id
    end
    @sleep_compact = @array_save.compact
    @sleep2 = Song.find_by(id: @sleep_compact[-1])
    
  end
  
  
  def search_modal_keep
    #밑에2줄 지워도됨
   # @test1 = params[:search_modal_main_song] #노래 id

    @feeling_address = params[:feeling_id] # 기분 주소 
    @feeling_address_id = Feeling.find_by(feeling_icon: params[:feeling_id]).id
    
    @current_user_list_array = Array.new
    #넘어온 곡의 아이디. hidden_value로 곡의 id가 넘어옴
    @find_song = Song.find_by(id: params[:search_modal_main_song])
    @find_song_array = Array.new
    #넘어온 곡의 id를 배열의 형태로 바꿔줌
    @find_song_array << @find_song.id
    #@current_user_list에 접속자의 lists 넣음.
    #현재 유저가 있으면 @current_user_list에 current_user.lists.all을 저장하겠다.
    unless current_user.nil?    
    @current_user_list = current_user.lists.all
    end
    #@current_user_list_array에 현재유저의 곡 id를 배열로 넣음
    @current_user_list.each do |hold|    
        @current_user_list_array << hold.song_id
    end
    
    #중복된 것은 저장안하기
    if (@find_song_array-@current_user_list_array).empty?
        else
        save_list = List.new
        save_list.user_id = current_user.id
        save_list.song_id = @find_song.id
        save_list.feeling_content = @feeling_address
        save_list.feeling_id = @feeling_address_id
        save_list.save        
    end

    @delete_thing = Presearch.all
    @delete_thing.each do |u|
      if u.user_id == current_user.id
        u.delete
      end
    end
    
    @test1 = params[:search_modal_main_song]
    @test2 = params[:feeling_id]
    @test3 = params[:hash_name]
    
    
    
    
     redirect_to "/whale/search?search_sing=" + URI.encode(params[:search_sing])
  end
  
  def search_modal_main
    #밑에2줄 지워도됨
   # @test1 = params[:search_modal_main_song] #노래 id

    @feeling_address = params[:feeling_id] # 기분 주소 
    @feeling_address_id = Feeling.find_by(feeling_icon: params[:feeling_id]).id
    
    @current_user_list_array = Array.new
    #넘어온 곡의 아이디. hidden_value로 곡의 id가 넘어옴
    @find_song = Song.find_by(id: params[:search_modal_main_song])
    @find_song_array = Array.new
    #넘어온 곡의 id를 배열의 형태로 바꿔줌
    @find_song_array << @find_song.id
    #@current_user_list에 접속자의 lists 넣음.
    #현재 유저가 있으면 @current_user_list에 current_user.lists.all을 저장하겠다.
    unless current_user.nil?    
    @current_user_list = current_user.lists.all
    end
    #@current_user_list_array에 현재유저의 곡 id를 배열로 넣음
    @current_user_list.each do |hold|    
        @current_user_list_array << hold.song_id  
        
    end
    
    #중복된 것은 저장안하기
    if (@find_song_array-@current_user_list_array).empty?
        else
        save_list = List.new
        save_list.user_id = current_user.id
        save_list.song_id = @find_song.id
        save_list.feeling_content = @feeling_address
        save_list.feeling_id = @feeling_address_id
        save_list.save        
        
    end


    @delete_thing = Presearch.all
    @delete_thing.each do |u|
      if u.user_id == current_user.id
        u.delete
      end
    end
    
    redirect_to :action => "main"
    
  end
  
  
  def similar
    if current_user.nil?
      redirect_to :action => "login"
    end
      @all_user = User.all
      @all_user_array = Array.new
      @all_user.each do |ket|
          @all_user_array << ket.id
      end
      @test = current_user.lists
      @test_array = Array.new
      @test.each do |jack|
        @test_array << jack.song_id
      end
      unless @test_array[0].nil?    #현재 유저가 있으면 session[:user_id]에 저장하겠다.
          @current_user_list_count = current_user.lists.count
          @all_user_id_except_me = @all_user_array-[current_user.id]         #나를 뺀 유저의 id 넣기
          @all_user_id_except_me_number = @all_user_id_except_me.sample()            #나를 뺀 유저의 id에서 sample로 1개 뽑기
          #이걸로 랜덤유저의 정보를 불러오면 된다.
          @pick_random_one_user =  User.find_by(id: @all_user_id_except_me_number)
          #클래스가 List
          @current_user_list = current_user.lists
          @current_user_list_song_id = Array.new
          #현재 접속 유저의 노래 정보
          @current_user_list.each do |kk|
              @current_user_list_song_id << kk.song_id
          end
          #@current_user_list_song_id에서 Song으로 노래 하나하나씩 잘 찾아오면 된다.
          @current_user_list_title = Array.new
          @current_user_list_singer = Array.new
          @current_user_list_album_img = Array.new
          @current_user_list_song_id.each do |tt|
              @current_user_list_title << Song.find_by(id: tt).title
              @current_user_list_singer << Song.find_by(id: tt).singer
              @current_user_list_album_img << Song.find_by(id: tt).album_img
          end
          #랜덤한 유저의 접속 정보
          #@pick_random_one_user_array_title = Array.new
          #@pick_random_one_user_array_singer = Array.new
          @pick_random_one_user_song_id = Array.new
          @pick_random_one_user_title = Array.new
          @pick_random_one_user_singer = Array.new
          @pick_random_one_user.lists.each do |pp|
              @pick_random_one_user_song_id << pp.song_id
          end
          @pick_random_one_user_song_id.each do |gg|
              @pick_random_one_user_title << Song.find_by(id: gg).title
              @pick_random_one_user_singer << Song.find_by(id: gg).singer
          end
          
        @percent_size = (((@current_user_list_title & @pick_random_one_user_title).size.to_f) / (@current_user_list_title.size).to_f).round(2)*100
        
            @my_feeling_icon_count = Array.new
            @your_feeling_icon_count = Array.new
              
            for a in (0..4)
            @my_feeling_icon_count[a] = Array.new
            @your_feeling_icon_count[a] = Array.new
            end
            
            @pre_feeling = List.all
            
            
          @pre_feeling.each do |prnum|
            for aa in 0..4
              if (prnum.user_id == current_user.id) & (prnum.feeling_id == aa+1)
                @my_feeling_icon_count[aa] << prnum.song_id
              end
            end
          end
          
          
          @pre_feeling.each do |prnum|
            for aa in 0..4
              if (prnum.user_id == @all_user_id_except_me_number) & (prnum.feeling_id == aa+1)
                @your_feeling_icon_count[aa] << prnum.song_id
              end
            end
          end
   
        
        # @same_component_list_size = (@pick_random_one_user_array & @current_user_list_array).size
        
      else
      redirect_to :action => "firstpage"
      end
      
    

  
  end
  
  
  def similar_modal
        if current_user.nil?
      redirect_to :action => "login"
    end
      @all_user = User.all
      @all_user_array = Array.new
      @all_user.each do |ket|
          @all_user_array << ket.id
      end
      @test = current_user.lists
      @test_array = Array.new
      @test.each do |jack|
        @test_array << jack.song_id
      end
      unless @test_array[0].nil?    #현재 유저가 있으면 session[:user_id]에 저장하겠다.
          @current_user_list_count = current_user.lists.count
          @all_user_id_except_me = @all_user_array-[current_user.id]         #나를 뺀 유저의 id 넣기
          @all_user_id_except_me_number = @all_user_id_except_me.sample()            #나를 뺀 유저의 id에서 sample로 1개 뽑기
          #이걸로 랜덤유저의 정보를 불러오면 된다.
          @pick_random_one_user =  User.find_by(id: @all_user_id_except_me_number)
          #클래스가 List
          @current_user_list = current_user.lists
          @current_user_list_song_id = Array.new
          #현재 접속 유저의 노래 정보
          @current_user_list.each do |kk|
              @current_user_list_song_id << kk.song_id
          end
          #@current_user_list_song_id에서 Song으로 노래 하나하나씩 잘 찾아오면 된다.
          @current_user_list_title = Array.new
          @current_user_list_singer = Array.new
          @current_user_list_album_img = Array.new
          @current_user_list_song_id.each do |tt|
              @current_user_list_title << Song.find_by(id: tt).title
              @current_user_list_singer << Song.find_by(id: tt).singer
              @current_user_list_album_img << Song.find_by(id: tt).album_img
          end
          #랜덤한 유저의 접속 정보
          #@pick_random_one_user_array_title = Array.new
          #@pick_random_one_user_array_singer = Array.new
          @pick_random_one_user_song_id = Array.new
          @pick_random_one_user_title = Array.new
          @pick_random_one_user_singer = Array.new
          @pick_random_one_user_album_img = Array.new
          @pick_random_one_user.lists.each do |pp|
              @pick_random_one_user_song_id << pp.song_id
          end
          @pick_random_one_user_song_id.each do |gg|
              @pick_random_one_user_title << Song.find_by(id: gg).title
              @pick_random_one_user_singer << Song.find_by(id: gg).singer
              @pick_random_one_user_album_img << Song.find_by(id: gg).album_img
          end
          
        @percent_size = (((@current_user_list_title & @pick_random_one_user_title).size.to_f) / (@current_user_list_title.size).to_f).round(2)*100
        
            @my_feeling_icon_count = Array.new
            @your_feeling_icon_count = Array.new
              
            for a in (0..4)
            @my_feeling_icon_count[a] = Array.new
            @your_feeling_icon_count[a] = Array.new
            end
            
            @pre_feeling = List.all
            
            
          @pre_feeling.each do |prnum|
            for aa in 0..4
              if (prnum.user_id == current_user.id) & (prnum.feeling_id == aa+1)
                @my_feeling_icon_count[aa] << prnum.song_id
              end
            end
          end
          
          
          @pre_feeling.each do |prnum|
            for aa in 0..4
              if (prnum.user_id == @all_user_id_except_me_number) & (prnum.feeling_id == aa+1)
                @your_feeling_icon_count[aa] << prnum.song_id
              end
            end
          end
   
        
        # @same_component_list_size = (@pick_random_one_user_array & @current_user_list_array).size
        
      else
      redirect_to :action => "firstpage"
      end
      
    

  end
  

  def tagsearch_joy
    @feeling_load = List.all
    @feeling_load_array = Array.new
      @feeling_load.each do |rr|
        if rr.feeling_id == 1
          @feeling_load_array << rr.song_id
        end
      end
      @feeling_song_array = Array.new
      @feeling_load_array.each do |ww|
        @feeling_song_array << Song.find_by(id: ww)
      end
      @feeling_song_array_title = Array.new
      @feeling_song_array_singer = Array.new
      @feeling_song_array.each do |qq|
        @feeling_song_array_title << qq.title
        @feeling_song_array_singer << qq.singer
      end
  end
  
  def tagsearch_lovely
    @feeling_load = List.all
    @feeling_load_array = Array.new
      @feeling_load.each do |rr|
        if rr.feeling_id == 2
          @feeling_load_array << rr.song_id
        end
      end
      @feeling_song_array = Array.new
      @feeling_load_array.each do |ww|
        @feeling_song_array << Song.find_by(id: ww)
      end
      @feeling_song_array_title = Array.new
      @feeling_song_array_singer = Array.new
      @feeling_song_array.each do |qq|
        @feeling_song_array_title << qq.title
        @feeling_song_array_singer << qq.singer
      end
  end
  
    def tagsearch_sad
    @feeling_load = List.all
    @feeling_load_array = Array.new
      @feeling_load.each do |rr|
        if rr.feeling_id == 3
          @feeling_load_array << rr.song_id
        end
      end
      @feeling_song_array = Array.new
      @feeling_load_array.each do |ww|
        @feeling_song_array << Song.find_by(id: ww)
      end
      @feeling_song_array_title = Array.new
      @feeling_song_array_singer = Array.new
      @feeling_song_array.each do |qq|
        @feeling_song_array_title << qq.title
        @feeling_song_array_singer << qq.singer
      end
  end
  
    def tagsearch_stress
    @feeling_load = List.all
    @feeling_load_array = Array.new
      @feeling_load.each do |rr|
        if rr.feeling_id == 4
          @feeling_load_array << rr.song_id
        end
      end
      @feeling_song_array = Array.new
      @feeling_load_array.each do |ww|
        @feeling_song_array << Song.find_by(id: ww)
      end
      @feeling_song_array_title = Array.new
      @feeling_song_array_singer = Array.new
      @feeling_song_array.each do |qq|
        @feeling_song_array_title << qq.title
        @feeling_song_array_singer << qq.singer
      end
  end
  
  def tagsearch_etc
    @feeling_load = List.all
    @feeling_load_array = Array.new
      @feeling_load.each do |rr|
        if rr.feeling_id == 5
          @feeling_load_array << rr.song_id
        end
      end
      @feeling_song_array = Array.new
      @feeling_load_array.each do |ww|
        @feeling_song_array << Song.find_by(id: ww)
      end
      @feeling_song_array_title = Array.new
      @feeling_song_array_singer = Array.new
      @feeling_song_array.each do |qq|
        @feeling_song_array_title << qq.title
        @feeling_song_array_singer << qq.singer
      end
      
     
        
    
  
  end
  
    



    
end


