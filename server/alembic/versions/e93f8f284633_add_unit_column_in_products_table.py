"""add unit column in products table

Revision ID: e93f8f284633
Revises: 33b95eef2be6
Create Date: 2024-04-18 12:36:35.225037

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'e93f8f284633'
down_revision: Union[str, None] = '33b95eef2be6'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('products', sa.Column('unit', sa.String(), nullable=False))
    # ### end Alembic commands ###


def downgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_column('products', 'unit')
    # ### end Alembic commands ###