"""add sold column to products table

Revision ID: 14523852c6f2
Revises: 7f3fa3eb6061
Create Date: 2024-05-03 17:52:25.348119

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '14523852c6f2'
down_revision: Union[str, None] = '7f3fa3eb6061'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_constraint('order_items_order_id_fkey', 'order_items', type_='foreignkey')
    op.create_foreign_key(None, 'order_items', 'orders', ['order_id'], ['order_id'])
    op.add_column('products', sa.Column('sold', sa.Integer(), nullable=True))
    # ### end Alembic commands ###


def downgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_column('products', 'sold')
    op.drop_constraint(None, 'order_items', type_='foreignkey')
    op.create_foreign_key('order_items_order_id_fkey', 'order_items', 'orders', ['order_id'], ['order_id'], onupdate='CASCADE', ondelete='CASCADE')
    # ### end Alembic commands ###