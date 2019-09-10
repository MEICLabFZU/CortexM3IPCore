////////////////////////////////////////////////////////////////////////////////
#ifndef __MAIN_H
#define __MAIN_H

#define STARTUP_TASK_PRIO					10
#define STARTUP_TASK_STK_SIZE				64
OS_STK startup_task_stk[STARTUP_TASK_STK_SIZE];

//LED1 任务
#define LED1_TASK_PRIO						6				//任务优先级
#define LED1_STK_SIZE						64				//任务堆栈大小
OS_STK LED1_TASK_STK[LED1_STK_SIZE];						//任务堆栈空间

//LED2 任务
#define LED2_TASK_PRIO						5				//任务优先级
#define LED2_STK_SIZE						64				//任务堆栈大小
OS_STK LED2_TASK_STK[LED2_STK_SIZE];						//任务堆栈空间

//LED3 任务
#define LED3_TASK_PRIO						7			//任务优先级
#define LED3_STK_SIZE						64				//任务堆栈大小
OS_STK LED3_TASK_STK[LED3_STK_SIZE];						//任务堆栈空间


#ifdef _MAIN_C_
#define GLOBAL

#else
#define GLOBAL extern
#endif






#undef GLOBAL
////////////////////////////////////////////////////////////////////////////////
void led1_task(void *p_arg);
void led2_task(void *p_arg);
void led3_task(void *p_arg);






#endif