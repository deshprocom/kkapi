class UserRelationCreator
  include Serviceable

  # c_user -> 当前注册的用户
  # p_user -> c_user的父级用户，受邀请用户
  def initialize(c_user, p_user)
    @c_user = c_user
    @p_user = p_user
  end

  def call
    # 没有人邀请的情况下
    return from_nobody if @p_user.blank?

    # 查询p_user用户的等级
    p_level = @p_user.r_level

    return from_our_user if p_level.zero? # 我们后台生成的用户 为普通用户 不参与三级分销模式

    from_first_level_user if p_level.eql?(1)
    # 被2级用户邀请
    from_second_level_user if p_level.eql?(2)
    # 被3级用户邀请
    from_third_level_user if p_level.eql?(3)
  end

  def from_nobody
    create_record(level: 1)
  end

  def from_our_user
    create_record(pid: @p_user.id, level: 1)
    @p_user.increase_invite_users
  end

  # 邀请人是1级用户，那么当前用户就是2级
  def from_first_level_user
    create_record(pid: @p_user.id, level: 2)
    @p_user.increase_invite_users
  end

  # 邀请人是2级用户，那么当前用户就是3级
  def from_second_level_user
    # 找出2级对应的用户
    g_user = @p_user.p_user
    create_record(pid: @p_user.id, gid: g_user.id, level: 3)
    @p_user.increase_invite_users
  end

  # 邀请人是3级用户，那么当前用户也是3级
  def from_third_level_user
    create_record(level: 3, pid: @p_user.id)
    @p_user.increase_invite_users
  end

  def create_record(params)
    UserRelation.create!({ user: @c_user }.merge(params))
    # 同步等级
    @c_user.update(r_level: params[:level])
  end
end
