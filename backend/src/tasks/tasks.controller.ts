import { Controller, Get, Post, Body, Patch, Param, Query } from '@nestjs/common';
import { TasksService } from './tasks.service';
import { CreateTaskDto } from './dto/create-task.dto';

@Controller('tasks')
export class TasksController {
  constructor(private readonly tasksService: TasksService) {}

  @Post()
  create(@Body() createTaskDto: CreateTaskDto) {
    return this.tasksService.create(createTaskDto);
  }

  @Get()
  findAll(@Query('status') status: string) {
    return this.tasksService.findAll(status);
  }

  @Patch(':id/done')
  markAsDone(@Param('id') id: string) {
    return this.tasksService.markAsDone(+id);
  }
}