package com.sky.mapper;

import com.sky.entity.User;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface UserMapper {

    /**
     * 根据openid查询用户
     * @param openid
     * @return
     */
    @Select("select * from user where openid = #{openid}")
    User getByOpenId(String openid);

    /**
     * 插入新用户
     * @param user
     */
    @Options(useGeneratedKeys = true,keyProperty = "id")
    @Insert("insert into user (id, openid, name, phone, sex, id_number, avatar, create_time) "
    + "values (#{id},#{openid},#{name},#{phone},#{sex},#{idNumber},#{avatar},#{createTime})")
    void insert(User user);

    /**
     * 通过id查询用户
     * @param userId
     * @return
     */
    @Select("select * from user where id = #{userId}")
    User getById(Long userId);
}
