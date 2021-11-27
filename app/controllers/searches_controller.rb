class SearchesController < ApplicationController

	def search
		@model = params[:model]
		@content = params[:content]
		if @model == 'user'
			@records = User.page(params[:page]).search_for(@content)
		else
			@records = Post.page(params[:page]).search_for(@content)
		end
	end
end
