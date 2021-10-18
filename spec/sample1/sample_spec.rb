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