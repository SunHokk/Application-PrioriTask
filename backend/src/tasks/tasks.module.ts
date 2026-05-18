import { Module } from '@nestjs/common';
import { TasksController } from './tasks.controller';
import { TasksService } from './tasks.service';
import { PriorityService } from '../priorities/priority.service';

@Module({
  controllers: [TasksController],
  providers: [TasksService, PriorityService],
  exports: [TasksService],
})
export class TasksModule {}
