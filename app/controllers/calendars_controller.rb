class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    get_week
    @plan = Plan.new

  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    # plan.rbモデルで定義されたもの
    # データを使うとき保存するときは全部モデル
    # ストロングパラメーター（なんのデータを取得するか）
    # createはメソッド名
    # paramsはビューから送られてきたデータを使うときの大きい箱（から選ぶ）
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan)
   # Calendersは送られていない、@Planがビューに送られている→plan
  end

  def get_week
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']

    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
    # 例)　今日が2月1日の場合・・・ Date.today.day => 1日

    @week_days = []

    plans = Plan.where(date: @todays_date..@todays_date + 6)

    7.times do |x|
      today_plans = []
      plans.each do |plan|
        today_plans.push(plan.plan) if plan.date == @todays_date + x
      end
      # days = { month: (@todays_date + x).month, date: (@todays_date+x).day, plans: today_plans}
      # @week_days.push(days)
       # 曜日の取得とフォーマット
      day_of_week = wdays[(@todays_date + x).wday]
      # 曜日情報と計画をハッシュに追加
      # days = { :month => (@todays_date + x).month, :date => (@todays_date + x).day, :day_of_week => day_of_week, :plans => today_plans }
      days = { month: (@todays_date + x).month, date: (@todays_date + x).day, day_of_week: day_of_week, plans: today_plans }
      @week_days.push(days)
      end

  end
end


# binding.pryは具体的な詳細を確かめたいとき