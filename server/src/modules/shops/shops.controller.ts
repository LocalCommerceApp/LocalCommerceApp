import { Controller, Get, Post, Body, Query, UseGuards, Req, NotFoundException } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { ShopsService } from './shops.service';
import { CreateShopDto } from './dto/create-shop.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';

@ApiTags('Shops')
@Controller('shops')
export class ShopsController {
  constructor(private readonly shopsService: ShopsService) {}

  @Get('my')
  @ApiBearerAuth()
  @UseGuards(JwtAuthGuard)
  @ApiOperation({ summary: "Get current user's shop" })
  async getMyShop(@Req() req: any) {
    const ownerId = req.user._id;
    const shop = await this.shopsService.findByOwner(ownerId);
    if (!shop) throw new NotFoundException('Shop not found');
    return shop;
  }

  @Get()
  @ApiOperation({ summary: 'Get all shops with optional filters' })
  async getShops(
    @Query('category') category?: string,
    @Query('shopType') shopType?: string,
    @Query('search') search?: string,
  ) {
    return this.shopsService.findFiltered(category, shopType, search);
  }

  @Post()
  @ApiBearerAuth()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('Shopkeeper', 'Admin')
  @ApiOperation({ summary: 'Create a new shop (Admin/Distributor only)' })
  async createShop(@Body() createShopDto: CreateShopDto) {
    return this.shopsService.create(createShopDto);
  }
}
