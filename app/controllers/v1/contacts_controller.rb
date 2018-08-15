module V1
  class ContactsController < ApplicationController
    def index
      @contacts = Contact.order(created_at: :desc).limit(3)
    end
  end
end
