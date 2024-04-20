"""add carts table

Revision ID: c31d845ffc9e
Revises: 70c608746865
Create Date: 2024-04-20 10:56:22.157268

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'c31d845ffc9e'
down_revision: Union[str, None] = '70c608746865'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    pass


def downgrade() -> None:
    pass
