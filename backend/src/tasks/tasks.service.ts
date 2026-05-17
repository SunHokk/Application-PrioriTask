import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Task } from './task.entity';
import { CreateTaskDto } from './dto/create-task.dto';

@Injectable()
export class TasksService {
  constructor(
    @InjectRepository(Task)
    private taskRepository: Repository<Task>,
  ) {}

  // Algoritma Utama: S = (Wd * (1 - P)) / (T + C)
  private calculatePriority(difficulty: number, progress: number, deadline: Date): number {
    const now = new Date();
    const T = (new Date(deadline).getTime() - now.getTime()) / (1000 * 60 * 60); // Sisa waktu dalam jam
    const timeFactor = T > 0 ? T : 0.1; // Menghindari pembagian nol
    const C = 0.1; 
    
    const score = (difficulty * (1 - progress)) / (timeFactor + C);
    return parseFloat(score.toFixed(4));
  }

  async create(createTaskDto: CreateTaskDto): Promise<Task> {
  const task = this.taskRepository.create(createTaskDto);
  
  if (task.progress === undefined || task.progress === null || isNaN(task.progress)) {
    task.progress = 0;
  }

  task.priorityScore = this.calculatePriority(task.difficulty, task.progress, task.deadline);
  return this.taskRepository.save(task);
}

  async findAll(status: string): Promise<Task[]> {
    const isCompleted = status === 'completed';
    const tasks = await this.taskRepository.find({
      where: { isCompleted },
      order: isCompleted ? { createdAt: 'DESC' } : { priorityScore: 'DESC' },
    });
    return tasks;
  }

async markAsDone(id: number): Promise<Task> {
    const task = await this.taskRepository.findOneBy({ id });

    // Jika task tidak ditemukan, lempar error agar aplikasi tidak crash
    if (!task) {
      throw new Error(`Task dengan ID ${id} tidak ditemukan`);
    }

    task.isCompleted = true;
    task.progress = 1.0;
    task.priorityScore = 0; 
    
    return this.taskRepository.save(task);
  }
}