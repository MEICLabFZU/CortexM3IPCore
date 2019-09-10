#include "SYN6288.h"
#include <string.h>


/**************Ğ¾Æ¬ÉèÖÃÃüÁî*********************/
uint8_t SYN_StopCom[]={0xFD,0X00,0X02,0X02,0XFD};//Í£Ö¹ºÏ³É
uint8_t SYN_SuspendCom[]={0XFD,0X00,0X02,0X03,0XFC};//ÔİÍ£ºÏ³É
uint8_t SYN_RecoverCom[]={0XFD,0X00,0X02,0X04,0XFB};//»Ö¸´ºÏ³É
uint8_t SYN_ChackCom[]={0XFD,0X00,0X02,0X21,0XDE};//×´Ì¬²éÑ¯
uint8_t SYN_PowerDownCom[]={0XFD,0X00,0X02,0X88,0X77};//½øÈëPOWER DOWN ×´Ì¬ÃüÁ

void SYN_FrameInfo(uint8_t Music,char *HZdata)
{
/****************ĞèÒª·¢ËÍµÄÎÄ±¾**********************************/ 
		 unsigned  char  Frame_Info[50] = {0xfd};
         unsigned  char  HZ_Length;  
		 unsigned  char  ecc  = 0;  			//¶¨ÒåĞ£Ñé×Ö½Ú
	     unsigned  int i=0; 
		 HZ_Length = strlen(HZdata); 			//ĞèÒª·¢ËÍÎÄ±¾µÄ³¤¶È
  
/*****************Ö¡¹Ì¶¨ÅäÖÃĞÅÏ¢**************************************/           
																//¹¹ÔìÖ¡Í·FD
		 Frame_Info[1] = 0x00 ; 		//¹¹ÔìÊı¾İÇø³¤¶ÈµÄ¸ß×Ö½Ú
		 Frame_Info[2] = HZ_Length + 3;		//¹¹ÔìÊı¾İÇø³¤¶ÈµÄµÍ×Ö½Ú
		 Frame_Info[3] = 0x01 ; 			//¹¹ÔìÃüÁî×Ö£ººÏ³É²¥·ÅÃüÁî		 		 
		 Frame_Info[4] = 0x01 | Music<<4 ;  //¹¹ÔìÃüÁî²ÎÊı£º±³¾°ÒôÀÖÉè¶¨
	
	
	

/*******************Ğ£ÑéÂë¼ÆËã***************************************/		 
		 for(i = 0; i<5; i++)   				//ÒÀ´Î·¢ËÍ¹¹ÔìºÃµÄ5¸öÖ¡Í·×Ö½Ú
	     {  
	         ecc=ecc^(Frame_Info[i]);		//¶Ô·¢ËÍµÄ×Ö½Ú½øĞĞÒì»òĞ£Ñé	
	     }

	   	 for(i= 0; i<HZ_Length; i++)   		//ÒÀ´Î·¢ËÍ´ıºÏ³ÉµÄÎÄ±¾Êı¾İ
	     {  
	         ecc=ecc^(HZdata[i]); 				//¶Ô·¢ËÍµÄ×Ö½Ú½øĞĞÒì»òĞ£Ñé		
	     }		 
/*******************·¢ËÍÖ¡ĞÅÏ¢***************************************/		  
		  memcpy(&Frame_Info[5], HZdata, HZ_Length);
		  Frame_Info[5+HZ_Length]=ecc;
		  PrintCom(Frame_Info,5+HZ_Length+1);
}

void PrintCom(uint8_t *DAT,uint8_t len)
{
	uint8_t i;
	for(i=0;i<len;i++)
	{
	 	Uart1Putc(*DAT++);
	}	
}