# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :load_task, only: %i[show update destroy]

  def index
    tasks = Task.all
    render status: :ok, json: { tasks: tasks }
  end

  def create
    task = Task.new(task_params)

    if task.save

      render status: :ok, json: { notice: t("successfully_created", entity: "Task") }

    else

      errors = task.errors.full_messages.to_sentence

      render status: :unprocessable_entity, json: { error: errors }

    end
  end

  def show
    render
  end

  def update
    if @task.update(task_params)

      render status: :ok, json: { notice: "Successfully updated task." }

    else

      render status: :unprocessable_entity,

        json: { error: @task.errors.full_messages.to_sentence }

    end
  end

  def destroy
    if @task.destroy

      render status: :ok, json: { notice: "Successfully deleted task." }

    else

      render status: :unprocessable_entity,

        json: { error: @task.errors.full_messages.to_sentence }

    end
  end

  private

    def load_task
      @task = Task.find_by(slug: params[:slug])
      unless @task
        render status: :not_found, json: { error: t("task.not_found") }
      end
  end

    def task_params
      params.require(:task).permit(:title, :assigned_user_id)
    end
end
