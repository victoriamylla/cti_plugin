# frozen_string_literal: true

# Redmine - project management software
# Copyright (C) 2006-2023  Jean-Philippe Lang
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

class WelcomeController < ApplicationController
  self.main_menu = false

  skip_before_action :check_if_login_required, only: [:robots]

  def index
    @news = News.latest User.current
    # @monitoramentoProjeto = nil
    
    
    if params[:monitoramentoId].present?
      @monitoramentoProjeto = Project.find(params[:monitoramentoId])
    else
      #@monitoramentoProjeto = Project.find(Setting.plugin_cti_plugin['projetoId_inicial'])
      @monitoramentoProjeto = Project.where(parent_id: nil).first
    end
    if params[:objetivoId].present?
      @objetivoProjeto = Project.find(params[:objetivoId])
      @monitoramentoProjeto = @objetivoProjeto.present? ? @objetivoProjeto.parent : nil
    else
      #@objetivoProjeto = Project.find(Setting.plugin_cti_plugin['objetivoId_inicial'])
      @objetivoProjeto =  (@monitoramentoProjeto.present? ? (@monitoramentoProjeto.children.present? ? @monitoramentoProjeto.children.first : nil) : nil)
    end
    if params[:krId].present?
      @krProjeto = Project.find(params[:krId])
      @objetivoProjeto = @krProjeto.present? ? @krProjeto.parent : nil
    else
      #@krProjeto =  Project.find(Setting.plugin_cti_plugin['krId_inicial'])
      @krProjeto = (@objetivoProjeto.present? ? (@objetivoProjeto.children.present? ? @objetivoProjeto.children.first : nil) : nil)
    end
  end

  def robots
    @projects = Project.visible(User.anonymous) unless Setting.login_required?
    render :layout => false, :content_type => 'text/plain'
  end
end
