import { Injectable } from '@nestjs/common';
import { TasksService } from '../tasks/tasks.service';
import { PriorityService } from '../priorities/priority.service';

@Injectable()
export class NotificationsService {
  constructor(
    private readonly tasksService: TasksService,
    private readonly priorityService: PriorityService,
  ) {}

  async getUrgentNotifications(): Promise<any[]> {
    const tasks = await this.tasksService.findAll();
    const now = new Date();

    const urgent = tasks
      .filter((task) => {
        if (task.is_completed) return false;
        const deadline = new Date(task.deadline);
        const daysLeft = (deadline.getTime() - now.getTime()) / 86_400_000;
        return daysLeft <= 3; // within 3 days
      })
      .sort(
        (a, b) =>
          new Date(a.deadline).getTime() - new Date(b.deadline).getTime(),
      )
      .slice(0, 3) // max 3 notifications
      .map((task) => {
        const deadline = new Date(task.deadline);
        const hoursLeft = Math.round(
          (deadline.getTime() - now.getTime()) / 3_600_000,
        );

        let message: string;
        if (hoursLeft < 0) {
          message = `Tugas "${task.task_name}" sudah melewati deadline!`;
        } else if (hoursLeft < 24) {
          message = `Tugas "${task.task_name}" deadline dalam ${hoursLeft} jam!`;
        } else {
          const daysLeft = Math.ceil(hoursLeft / 24);
          message = `Tugas "${task.task_name}" deadline dalam ${daysLeft} hari.`;
        }

        return {
          id: task.id,
          task_id: task.id,
          task_name: task.task_name,
          subject_name: task.subject_name,
          deadline: task.deadline,
          priority_score: task.priority_score,
          message,
          is_overdue: hoursLeft < 0,
          hours_left: hoursLeft,
        };
      });

    return urgent;
  }
}
