"""add delivery_schedules table

Revision ID: 12c4bc6da42e
Revises: e0d5a55a5524
Create Date: 2024-05-06 08:03:36.969600

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '12c4bc6da42e'
down_revision: Union[str, None] = 'e0d5a55a5524'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('delivery_schedules',
    sa.Column('deliver_id', sa.Integer(), autoincrement=True, nullable=False),
    sa.Column('seller_id', sa.Integer(), nullable=False),
    sa.Column('schedule', sa.String(), nullable=True),
    sa.ForeignKeyConstraint(['seller_id'], ['sellers.id'], onupdate='CASCADE', ondelete='CASCADE'),
    sa.PrimaryKeyConstraint('deliver_id')
    )
    # ### end Alembic commands ###


def downgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_table('delivery_schedules')
    # ### end Alembic commands ###
