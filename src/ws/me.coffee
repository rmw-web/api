export default (uid)->
  @uid = uid = uid or 1234
  return [uid, "测试用户"]


