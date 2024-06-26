"""add is_verified col on user table

Revision ID: e0d5a55a5524
Revises: 467fa151df50
Create Date: 2024-05-04 09:24:07.343130

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'e0d5a55a5524'
down_revision: Union[str, None] = '467fa151df50'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('users', sa.Column('is_verified', sa.Boolean(), nullable=True))
    # ### end Alembic commands ###


def downgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_column('users', 'is_verified')
    # ### end Alembic commands ###
