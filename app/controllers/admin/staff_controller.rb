class Admin::StaffController < ApplicationController
  layout 'admin'

  def new
    @staff = Staff.new
  end

  def update

  end
end