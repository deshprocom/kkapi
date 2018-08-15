module V1
  class ContactsController < ApplicationController
    def index
      @contact = Contact.order(created_at: :desc).first
    end
  end
end
