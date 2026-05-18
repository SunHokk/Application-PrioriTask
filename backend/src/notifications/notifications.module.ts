import { Module } from '@nestjs/common';
import { NotificationsController } from './notifications.controller';
import { NotificationsService } from './notifications.service';
import { TasksModule } from '../tasks/tasks.module';
import { PriorityService } from '../priorities/priority.service';

@Module({
  imports: [TasksModule],
  controllers: [NotificationsController],
  providers: [NotificationsService, PriorityService],
})
export class NotificationsModule {}
