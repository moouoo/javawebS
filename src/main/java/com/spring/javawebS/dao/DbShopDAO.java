package com.spring.javawebS.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.javawebS.vo.DbBaesongVO;
import com.spring.javawebS.vo.DbCartVO;
import com.spring.javawebS.vo.DbOptionVO;
import com.spring.javawebS.vo.DbOrderVO;
import com.spring.javawebS.vo.DbProductVO;
import com.spring.javawebS.vo.MemberVO;

public interface DbShopDAO {

	public List<DbProductVO> getCategoryMain();

	public void setCategoryMainInput(@Param("vo") DbProductVO vo);

	public DbProductVO getCategoryMainOne(@Param("categoryMainCode") String categoryMainCode, @Param("categoryMainName")  String categoryMainName);

	public List<DbProductVO> getCategoryMiddle();

	public DbProductVO getCategoryMiddleOne(@Param("vo") DbProductVO vo);

	public void setCategoryMiddleInput(@Param("vo") DbProductVO vo);

	public List<DbProductVO> getCategorySub();

	public List<DbProductVO> getCategoryMiddleName(@Param("categoryMainCode") String categoryMainCode);

	public DbProductVO getCategorySubOne(@Param("vo") DbProductVO vo);

	public void setCategorySubInput(@Param("vo") DbProductVO vo);

	public List<DbProductVO> getCategorySubName(@Param("categoryMainCode") String categoryMainCode, @Param("categoryMiddleCode") String categoryMiddleCode);

	public List<DbProductVO> getCategoryProductName(@Param("categoryMainCode") String categoryMainCode, @Param("categoryMiddleCode") String categoryMiddleCode, @Param("categorySubCode") String categorySubCode);

	public DbProductVO getProductMaxIdx();

	public void setDbProductInput(@Param("vo") DbProductVO vo);

	public List<DbProductVO> getSubTitle();

	public List<DbProductVO> getDbShopList(@Param("part") String part);

	public DbProductVO getDbShopProduct(@Param("idx") int idx);

	public DbProductVO getProductInfor(@Param("productName") String productName);

	public List<DbOptionVO> getOptionList(@Param("productIdx") int productIdx);

	public void setDbOptionInput(@Param("vo") DbOptionVO vo);

	public int getOptionSame(@Param("productIdx") int productIdx, @Param("optionName") String optionName);

	public void setOptionDelete(@Param("idx") int idx);

	public List<DbOptionVO> getDbShopOption(@Param("productIdx") int productIdx);

	public void setCategoryMainDelete(@Param("categoryMainCode") String categoryMainCode);

	public void setCategoryMiddleDelete(@Param("categoryMiddleCode") String categoryMiddleCode);

	public DbProductVO getDbProductOne(@Param("categorySubCode") String categorySubCode);

	public void setCategorySubDelete(@Param("categorySubCode") String categorySubCode);

	public DbCartVO getDbCartProductOptionSearch(@Param("productName") String productName, @Param("optionName") String optionName, @Param("mid") String mid);

	public void dbShopCartUpdate(@Param("vo") DbCartVO vo);

	public void dbShopCartInput(@Param("vo") DbCartVO vo);

	public List<DbCartVO> getDbCartList(@Param("mid") String mid);

	public void dbCartDelete(@Param("idx") int idx);

	public DbCartVO getCartIdx(@Param("idx") int idx);

	public DbOrderVO getOrderMaxIdx();

	public void setDbOrder(@Param("vo") DbOrderVO vo);

	public void setDbCartDeleteAll(@Param("idx") int idx);

	public void setDbBaesong(@Param("baesongVO") DbBaesongVO baesongVO);

	public void setMemberPointPlus(@Param("point") int point, @Param("mid") String mid);

	public List<DbBaesongVO> getOrderBaesong(@Param("orderIdx") String orderIdx);

	public List<DbBaesongVO> getMyOrderList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, @Param("mid") String mid);

	public int totRecCnt(@Param("mid") String mid);

	public int totRecCntMyOrderStatus(@Param("mid") String mid, @Param("startJumun") String startJumun, @Param("endJumun") String endJumun, @Param("conditionOrderStatus") String conditionOrderStatus);

	public List<DbBaesongVO> getMyOrderStatus(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, @Param("mid") String mid, @Param("startJumun") String startJumun, @Param("endJumun") String endJumun, @Param("conditionOrderStatus") String conditionOrderStatus);

	public List<DbBaesongVO> getOrderCondition(@Param("mid") String mid, @Param("conditionDate") int conditionDate, @Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

}
