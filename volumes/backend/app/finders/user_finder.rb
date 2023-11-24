# TODO: 新仕様にあわせてリプレースする
class UserFinder
  attr_reader :params

  def initialize(params: {})
    @params = params
  end

  def execute
    users = base_scope
    users = by_id(users)
    users = by_name(users)

    order(users)
  end

  private

  def base_scope
    User.all
  end

  def by_id(users)
    return users unless params[:id]

    users.where(id: params[:id])
  end

  def by_name(users)
    return users unless params[:name]

    users.where(name: params[:name])
  end

  def order(users)
    return users unless params[:sort]

    users.order_by(params[:sort])
  end
end
