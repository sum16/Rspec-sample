require 'rails_helper'

RSpec.describe MoviesController, type: :controller do
  render_views
  describe 'Station1 GET /movies' do
    before do
      create_list(:movie, 3)
      get 'index'
    end

    it '200を返すこと' do
      expect(response).to have_http_status(200)
    end

    it 'HTMLを返すこと' do
      expect(response.body).to include('<!DOCTYPE html>')
    end

    it 'HTMLの中にはmoviesテーブルのレコード数と同じ件数のデータがあること' do
      movies = Movie.all
      expect(response.body).to include(movies[0].name).and include(movies[1].name).and include(movies[2].name).and include(movies[0].image_url).and include(movies[1].image_url).and include(movies[2].image_url)
    end
  end
end


--------------------------------------------------------------------------------------

require 'rails_helper'
RSpec::Matchers.define_negated_matcher :not_include, :include

RSpec.describe Admin::MoviesController, type: :controller do
  render_views
  describe 'Station2 GET /admin/movies' do
    let!(:movies) { create_list(:movie, 3) }
    before { get 'index' }

    it '200を返すこと' do
      expect(response).to have_http_status(200)
    end

    it 'HTMLを返すこと' do
      expect(response.body).to include('<!DOCTYPE html>')
    end

    it 'HTMLの中にはtableタグがあること' do
      expect(response.body).to include('<table>')
    end

    it 'HTMLの中にはmoviesテーブルの件数と同じだけのデータがあること' do
      expect(response.body).to include(movies[0].name).and include(movies[1].name).and include(movies[2].name).and include(movies[0].image_url).and include(movies[1].image_url).and include(movies[2].image_url)
    end

    it 'HTMLの中にはtrue/falseが含まれないこと' do
      expect(response.body).to not_include('true').and not_include('false')
    end

    describe 'HTMLの中にはmoviesテーブルのカラムすべてが表示されていること' do
      it 'moviesテーブルのname,year,descriptionカラムが表示されていること' do
        expect(response.body).to include(movies.first.name).and include("#{movies.first.year}").and include(movies.first.description)
      end

      it 'moviesテーブル内のimage_urlが画像として表示されていること' do
        expect(response.body).to include("<img src=\"#{movies.first.image_url}\"")
      end
    end
  end
end



------------------------------------------------------------------------

require 'rails_helper'

RSpec.describe Admin::MoviesController, type: :controller do
  render_views
  describe 'Station3 GET /admin/movies/new' do
    before do
      get 'new'
    end

    it '200を返すこと' do
      expect(response).to have_http_status(200)
    end

    it 'HTMLを返すこと' do
      expect(response.body).to include('<!DOCTYPE html>')
    end

    it 'HTMLの中にはformタグがあること' do
      expect(response.body).to include('</form>')
    end

    it '改行したテキストの送信時にDBに改行コードは許容されるか' do
      expect(response.body).to include('</textarea>')
    end
  end

  describe 'Station3 POST /admin/movies' do
    let!(:movie_attributes) { attributes_for(:movie) }

    it '302を返すこと' do
      post :create, params: { movie: movie_attributes }, session: {}
      expect(response).to have_http_status(302)
    end

    it 'エラー処理がされていて仮にRailsデフォルトのエラー画面が出ないこと' do
      # 今回はデータベースエラーで例外処理
      post :create, params: { movie: { name: "test", is_showing: true ,image_url: "https://techbowl.co.jp/_nuxt/img/111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111lllllllllllll.png" } }, session: {}
      expect(response).to have_http_status(:ok)
    end

    it 'DBに保存されていること' do
      expect do
        post :create, params: { movie: movie_attributes }, session: {}
      end.to change(Movie, :count).by(1)
    end
  end
end



---------------------------------------------------------------------------------------


require 'rails_helper'

RSpec.describe Admin::MoviesController, type: :controller do
  render_views
  describe 'Station4 GET /admin/movies/:id/edit' do
    let!(:movie) { create(:movie) }
    before { get 'edit', params: {id: movie.id} }

    it '200を返すこと' do
      expect(response).to have_http_status(200)
    end

    it 'HTMLを返すこと' do
      expect(response.body).to include('<!DOCTYPE html>')
    end

    it 'HTMLの中にはformタグがあること' do
      expect(response.body).to include('</form>')
    end

    it 'フォーム内に予め movies(:id) のレコードに対応する値が入っていること' do
      expect(response.body).to include(movie.name)
    end
  end

  describe 'Station4 PUT /admin/movies/:id' do
    let!(:movie) { create(:movie) }
    let!(:movie_attributes) { { name: "TEST" } }

    it '302を返すこと' do
      post :update, params: { id: movie.id, movie: movie_attributes }, session: {}
      expect(response).to have_http_status(302)
    end

    it 'エラー処理がされていて仮にRailsデフォルトのエラー画面が出ないこと' do
      # 今回はデータベースエラーで例外処理
      post :update, params: { id: movie.id, image_url: "https://techbowl.co.jp/_nuxt/img/111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111lllllllllllll.png" }, session: {}
      expect(response).to have_http_status(:ok)
    end
  end
end

------------------------------------------------------------------------


require 'rails_helper'

RSpec.describe Admin::MoviesController, type: :controller do
  render_views
  describe 'Station5 DELETE admin/movies/:id' do
    let!(:movie) { create(:movie) }
    it 'リクエストを送ると320が返り、movies(:id)のレコードが消えること' do
      expect do
        delete :destroy, params: { id: movie.id }, session: {}
      end.to change(Movie, :count).by(-1)
      expect(response).to have_http_status(302)
    end
  
    it ':idのレコードが存在しないときRecordNotFound(400)が返る' do
      nothing_movie_id = movie.id + 1
      expect do
        delete :destroy, params: { id: nothing_movie_id }, session: {}
      end.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end
end

------------------------------------------------------------------------

require 'rails_helper'
RSpec::Matchers.define_negated_matcher :not_include, :include

RSpec.describe MoviesController, type: :controller do
  render_views
  describe 'Station6 GET /movies' do
    let!(:movies) { create_list(:movie, 3) }
    before do
      get 'index'
    end

    it '200を返すこと' do
      expect(response).to have_http_status(200)
    end

    it 'HTMLを返すこと' do
      expect(response.body).to include('<!DOCTYPE html>')
    end
    
    it 'HTMLの中にはmoviesテーブルのレコード数と同じ件数のデータがあること' do
      expect(response.body).to include(movies[0].name).and include(movies[1].name).and include(movies[2].name).and include(movies[0].image_url).and include(movies[1].image_url).and include(movies[2].image_url)
    end

    it 'method = getのformがある' do
      expect(response.body).to include('method="get"')
    end

    context '検索時' do
      # factoriesのis_showingのデフォルトでは1
      let!(:show_estimated) { create(:movie, is_showing: 0 ) }
      let!(:showed_movie) { create(:movie, is_showing: 1 ) }
  
      it '検索キーワードを指定するとそれを含むものだけ表示' do
        get :index, params: { name: show_estimated.name, is_showing: "" }
        expect(response.body).to include(show_estimated.name)
        expect(response.body).to not_include(showed_movie.name)
      end

      it '公開中か公開前の切り替えができる' do
        get :index, params: { name: "", is_showing: 1 }
        expect(response.body).to include("公開予定")
      end
    end
  end
end


------------------------------------------------------------------------


require 'rails_helper'

RSpec.describe SheetsController, type: :controller do
  render_views
  describe 'Station7 GET /sheets' do
    let!(:sheets) { create_list(:sheet, 5) } 
    before do
      get 'index'
    end

    it '200を返すこと' do
      expect(response).to have_http_status(200)
    end

    it 'HTMLの中にはtableタグがあること' do
      expect(response.body).to include('</table>')
    end

    it '実装の中でsheetsテーブルにアクセスしていること' do
      expect(response.body).to include("#{sheets.first.column}").and include("#{sheets.last.column}")
    end
  end
end


------------------------------------------------------------------------


require 'rails_helper'

RSpec.describe MoviesController, type: :controller do
  render_views
  describe 'Station6 GET /movies' do
    let!(:movie) { create(:movie) }
    before do
      @schedules = create_list(:schedule, 3, movie_id: movie.id)
      get :show, params: { id: movie.id }, session: {}
    end 

    it 'movies(:id)に対応するレコードの情報が含まれていること' do
      expect(response.body).to include(movie.name).and include("#{movie.year}").and include(movie.description).and include(movie.image_url)
    end

    it 'movies(:id)に紐づくschedulesのレコード全件分のデータが出力されていること' do
      expect(response.body).to include(@schedules[0].start_time.to_s).and include(@schedules[2].start_time.to_s)
    end
  end
end


------------------------------------------------------------------------


require 'rails_helper'

RSpec.describe SchedulesController, type: :controller do
  render_views
  describe 'Station9 GET /admin/schedules/:id' do
    let!(:movie) { create(:movie) }
    let!(:schedule) { create(:schedule, movie_id: movie.id) }
    before { get :edit, params: { id: schedule.id, movie_id: movie.id } }

    it '時刻のフォームに時刻以外のものを入力できないこと' do
      # TODO: capybaraでテスト実装
    end

    it 'フォーム送信でPUT /schedule/:id に送信されること' do
      expect(response.body).to include('action="/admin/schedules/')
    end
  end

  describe 'Station9 PUT /schedules/:id' do
    let!(:movie) { create(:movie) }
    let!(:schedule) { create(:schedule, movie_id: movie.id) }
    let!(:setting_time) { "2000-01-01 10:27:06 UTC" } 
    let!(:schedule_attributes) { { start_time: setting_time } }
    before { post :update, params: { id: schedule.id, schedule: schedule_attributes }, session: {} }

    it '渡された時刻でschedule(:id)が更新されること' do
      updatedSchedule = Schedule.find(schedule.id)
      expect(updatedSchedule.start_time).to eq setting_time
    end
  end

  describe 'Station9 DELETE /schedule/:id' do
    let!(:movie) { create(:movie) }
    let!(:schedule) { create(:schedule, movie_id: movie.id) }

    it '渡された時刻でschedule(:id)が更新されること' do
      expect do
        delete :destroy, params: { id: schedule.id }, session: {}
      end.to change(Schedule, :count).by(-1)
    end
  end
end

#9までok
------------------------------------------------------------------------

